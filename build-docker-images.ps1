echo "Building Frontend App"
docker build -t dpm-frontend-app:latest .\frontend-app\

echo ""
echo "Building API Gateway"
docker build -t dpm-api-gateway:latest .\api-gateway\src\ProjectManagement.ApiGateway\
