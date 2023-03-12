# Project Management App

| Project                                                                                  |                                                                                                                Sonar Status                                                                                                                 |                                                                                                          Build Status                                                                                                          | Release Status |
|:-----------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:--------------:|
| [Api Gateway](https://github.com/afroze9/dotnet-projectmanagement-api-gateway)           |                                                                                                                                                                                                                                             |                                                                                                                                                                                                                                |                |
| [Discovery Server](https://github.com/afroze9/dotnet-projectmanagement-discovery-server) |                                                                                                                                                                                                                                             |                                                                                                                                                                                                                                |                |
| [Company Api](https://github.com/afroze9/dotnet-projectmanagement-company-api)           | [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=afroze9_dotnet-projectmanagement-company-api&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=afroze9_dotnet-projectmanagement-company-api) | [![Build](https://github.com/afroze9/dotnet-projectmanagement-company-api/actions/workflows/dotnet.yml/badge.svg?branch=master)](https://github.com/afroze9/dotnet-projectmanagement-company-api/actions/workflows/dotnet.yml) |                |
| [Project Api](https://github.com/afroze9/dotnet-projectmanagement-project-api)           |                                                                                                                                                                                                                                             |                                                                                                                                                                                                                                |                |
| [Frontend App](https://github.com/afroze9/dotnet-projectmanagement-frontend-app)         |                                                                                                                                                                                                                                             |                                                                                                                                                                                                                                |                |

# TODO

* [x] Finalize Project Scope
* [ ] Task Assignment
* [ ] Trainings
* [ ] Development
* [ ] Documentation
* [ ] Component Integration
* [ ] Presentation / Demo
* [ ] Move ACL for each microservice to its own service directory

# Project Scope

Create a simple microservices based application with the following components:

* [ ] Service Discovery (Consul)
    * [x] Basic Setup
    * [x] Basic ACL
    * [ ] mTLS
    * [ ] Policies/Tokens via config files
* [ ] Configuration Server **(One or more of)**
    * [x] Consul KV
    * [ ] Vault
* [ ] Api Gateway (Ocelot)
    * [x] Base Setup (Consul + Auth)
    * [ ] Add routes for company-api
    * [ ] Add routes for project-api
* [ ] Logging/Monitoring **(One of)**
    * [ ] Azure Application Insights
    * [ ] ELK
* [ ] Tracing **(One or more of)**
    * [ ] OpenTelemetry
    * [ ] Zipkin
* [ ] Authentication/Authorization **(One of)**
    * [ ] Azure AD
    * [ ] Keycloak
    * [ ] Identity Server
* [ ] Health checks (Steeltoe)
* [ ] Deployment Model (Kubernetes)
* [ ] CI/CD Pipeline (Azure DevOps)
* [ ] Testing Framework (xUnit/Moq)
    * [ ] Unit Tests
    * [ ] Integration Tests
    * [ ] E2E Tests
* [ ] Backend Apis (.NET 7)
    * [ ] Company Api
    * [ ] Project Api
* [ ] Frontend Application
    * [ ] React App
    * [ ] Tests

# Getting Started

## Consul

### Download/Setup

* Download Consul binary from [Consul's Website](https://developer.hashicorp.com/consul/downloads)
* Extract Consul binary to any location e.g. `C:\tools\consul`
* Add location to `PATH`

### Start Agent

```powershell
consul.exe agent -config-file="config\\config.hcl"
```

### Bootstrap ACL

```powershell
consul.exe acl bootstrap
```

Save the secret-id generated by this command.

### Create token for Consul Server

```powershell
consul.exe acl token create -description "Token for consul-server-1" -node-identity "consul-server-1:az-1" -token="<bootstrap-token>"
```

Reload config `consul.exe reload`

### Create tokens for services

Run the `add-policies.ps1` script under `discovery-server` folder

Use the generated secret-ids in `appsettings.json` for each service

### Create startup configs

Run the `add-keyvalues.ps1` script under `discovery-server` folder