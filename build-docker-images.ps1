echo "Building Frontend App"
docker build -t dpm-frontend-app:latest .\frontend-app\

echo ""
echo "Building API Gateway"
Push-Location ".\api-gateway\"
docker build -t dpm-api-gateway:latest -f "src\ProjectManagement.ApiGateway\Dockerfile" .
Pop-Location

echo ""
echo "Building Company API"
Push-Location ".\company-api\"
docker build -t dpm-company-api:latest -f "src\ProjectManagement.Company.Api\Dockerfile" .
Pop-Location

echo ""
echo "Building Project API"
Push-Location ".\project-api\"
docker build -t dpm-project-api:latest -f "src\ProjectManagement.Project.Api\Dockerfile" .
Pop-Location

echo ""
echo "Building Health Checks Dashboard"
Push-Location ".\health-checks-dashboard\"
docker build -t dpm-health-checks-dashboard:latest -f "src\ProjectManagement.HealthChecksDashboard\Dockerfile" .
Pop-Location
