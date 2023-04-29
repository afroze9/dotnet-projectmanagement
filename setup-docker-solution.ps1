function Get-EnvValue([string]$name) {
    $envFile = Get-Content -Path ".env"
    foreach ($line in $envFile) {
        if ($line.Trim().StartsWith($name + "=")) {
            return $line.Split("=")[1]
        }
    }
    return $null
}

echo "Increasing WSL memory for ELK"
wsl -d docker-desktop sysctl -w vm.max_map_count=262144

echo ""
echo "Building Docker Images"
.\build-docker-images.ps1

echo ""
echo "Starting Consul"
Push-Location ".\discovery-server\docker\"
&".\setup-consul.ps1" "token"
Pop-Location

echo ""
echo "Setting up ACL for api-gateway"
Push-Location ".\api-gateway\src\ProjectManagement.ApiGateway\Consul\"
&".\setup-consul.ps1" "api_gateway_token"
Pop-Location

echo ""
echo "Setting up ACL for company-api"
Push-Location ".\company-api\src\ProjectManagement.Company.Api\Consul"
&".\setup-consul.ps1" "company_api_token"
Pop-Location

echo ""
echo "Setting up ACL for project-api"
Push-Location ".\project-api\src\ProjectManagement.Project.Api\Consul"
&".\setup-consul.ps1" "project_api_token"
Pop-Location

echo ""
echo "Copying tokens to .env file"
(Get-Content .env) |
ForEach-Object { $_ -replace "^API_GATEWAY_TOKEN=.*", "API_GATEWAY_TOKEN=$api_gateway_token" } |
ForEach-Object { $_ -replace "^COMPANY_API_TOKEN=.*", "COMPANY_API_TOKEN=$company_api_token" } |
ForEach-Object { $_ -replace "^PROJECT_API_TOKEN=.*", "PROJECT_API_TOKEN=$project_api_token" } |
Set-Content .env

echo ""
echo "Setting up databases, elk, and jaeger"
docker-compose -f .\docker-compose.yml up -d

$api_gateway_port = Get-EnvValue "API_GATEWAY_PORT_EXTERNAL"

echo ""
echo "Setup complete"
echo "Global Token: $token"
echo "API Gateway Token: $api_gateway_token"
echo "Company API Token: $company_api_token"
echo "Project API Token: $project_api_token"
echo "-------------------------------------"
echo "API Gateway running at https://localhost:$api_gateway_port"
