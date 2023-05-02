function Get-EnvValue([string]$name) {
    $envFile = Get-Content -Path ".env"
    foreach ($line in $envFile) {
        if ($line.Trim().StartsWith($name + "=")) {
            return $line.Split("=")[1]
        }
    }
    return $null
}

echo "Generating Dev Certs"
$CreateCert = (dotnet dev-certs https -c | Select-String -SimpleMatch "No valid certificate found.")
if($CreateCert) {
    dotnet dev-certs https --trust
}
dotnet dev-certs https -ep ./devcerts/aspnetapp.pfx -p $devCertPassword

echo ""
echo "Increasing WSL memory for ELK"
wsl -d docker-desktop sysctl -w vm.max_map_count=262144

#echo ""
#echo "Building Docker Images"
#.\build-docker-images.ps1

echo ""
echo "Checking Docker Networks"
$networkName = "consul-external"
$networkList = docker network ls --filter name=$networkName --format "{{.Name}}"
if ($networkList -contains $networkName) {
    Write-Host "The '$networkName' network already exists."
} else {
    docker network create $networkName
    Write-Host "The '$networkName' network has been created."
}
$networkId = docker network inspect $networkName --format='{{.Id}}'
$subnetIp = docker network inspect $networkId --format='{{(index .IPAM.Config 0).Subnet}}'
echo "The Subnet IP is $subnetIp"

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
docker-compose -f .\docker-compose-local.yml up -d

$api_gateway_port = Get-EnvValue "API_GATEWAY_PORT_EXTERNAL"
$company_api_port = Get-EnvValue "COMPANY_API_PORT_EXTERNAL"
$project_api_port = Get-EnvValue "PROJECT_API_PORT_EXTERNAL"

echo ""
echo "----------------------------------------------"
echo "Setup complete"
echo "Global Token: $token"
echo "----------------------------------------------"
echo "Consul running at http://localhost:8500"
echo "Kibana running at http://localhost:5601"
echo "----------------------------------------------"
