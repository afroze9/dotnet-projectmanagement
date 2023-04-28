echo "Starting Consul"
Push-Location ".\discovery-server\docker\"
&".\setup-consul.ps1" "token"
Pop-Location

echo ""
echo "Setting up ACL for api-gateway"
Push-Location ".\api-gateway\src\ProjectManagement.ApiGateway\Consul\"
.\setup-consul.ps1
Pop-Location

echo ""
echo "Setting up ACL for company-api"
Push-Location ".\company-api\src\ProjectManagement.Company.Api\Consul"
.\setup-consul.ps1
Pop-Location

echo ""
echo "Setting up ACL for project-api"
Push-Location ".\project-api\src\ProjectManagement.Project.Api\Consul"
.\setup-consul.ps1
Pop-Location

echo ""
echo "Setting up databases, elk, and jaeger"
docker-compose -f .\docker-compose.yml up -d

echo ""
echo "Done"
echo "Token: $token"

