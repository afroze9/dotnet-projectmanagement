echo "Building Frontend App"
docker build -t dpm-frontend-app:latest .\frontend-app\

echo ""
echo "Building API Gateway"
docker build -t dpm-api-gateway:latest .\api-gateway\src\ProjectManagement.ApiGateway\

echo ""
echo "Building Company API"
docker build -t dpm-company-api:latest .\company-api\src\ProjectManagement.Company.Api\

echo ""
echo "Building Project API"
docker build -t dpm-project-api:latest .\project-api\src\ProjectManagement.Project.Api\
