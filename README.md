# Project Management App

| Project                                                                                  |                                                                                                                Sonar Status                                                                                                                 |                                                                                                          Build Status                                                                                                          | Release Status |
|:-----------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:--------------:|
| [Api Gateway](https://github.com/afroze9/dotnet-projectmanagement-api-gateway)           |                                                                                                                                                                                                                                             |                                                                                                                                                                                                                                |                |
| [Discovery Server](https://github.com/afroze9/dotnet-projectmanagement-discovery-server) |                                                                                                                     N/A                                                                                                                     |                                                                                                              N/A                                                                                                               |                |
| [Company Api](https://github.com/afroze9/dotnet-projectmanagement-company-api)           | [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=afroze9_dotnet-projectmanagement-company-api&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=afroze9_dotnet-projectmanagement-company-api) | [![Build](https://github.com/afroze9/dotnet-projectmanagement-company-api/actions/workflows/dotnet.yml/badge.svg?branch=master)](https://github.com/afroze9/dotnet-projectmanagement-company-api/actions/workflows/dotnet.yml) |                |
| [Project Api](https://github.com/afroze9/dotnet-projectmanagement-project-api)           | [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=afroze9_dotnet-projectmanagement-project-api&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=afroze9_dotnet-projectmanagement-project-api) |        [![Build](https://github.com/afroze9/dotnet-projectmanagement-project-api/actions/workflows/dotnet.yml/badge.svg)](https://github.com/afroze9/dotnet-projectmanagement-project-api/actions/workflows/dotnet.yml)        |                |
| [Frontend App](https://github.com/afroze9/dotnet-projectmanagement-frontend-app)         |                                                                                                                                                                                                                                             |                                                                                                                                                                                                                                |                |

# TODO

* [x] Finalize Project Scope
* [ ] Task Assignment
* [x] Trainings
    * [x] Docker
* [ ] Development
* [ ] Documentation
* [ ] Component Integration
* [ ] Presentation / Demo
* [x] Move ACL for each microservice to its own service directory
* [ ] [Use certificates generated by Elastic to validate serilog connection](https://www.elastic.co/guide/en/elasticsearch/client/net-api/2.x/working-with-certificates.html)

# Project Scope

Create a simple microservices based application with the following components:

* [ ] Service Discovery (Consul)
    * [x] Basic Setup
    * [x] Setup Scripts
    * [x] ACL Setup
    * [ ] mTLS Setup
* [x] Configuration Server **(One or more of)**
    * [x] Consul KV
    * [ ] ~~Vault~~
* [x] Api Gateway (Ocelot)
    * [x] Project Setup
    * [x] Connection with Consul
    * [x] Auth Implementation
    * [x] Add routes for company-api
    * [x] Add routes for project-api
    * [x] Consul Policies
    * [x] Consul Configuration
* [x] Logging/Monitoring **(One of)**
    * [ ] ~~Azure Application Insights~~
    * [x] ELK
        * [x] [Create Docker Compose Files](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
* [x] Tracing
    * [x] Setup Jaeger using Docker
* [x] Authentication/Authorization **(One of)**
    * [ ] ~~Azure AD~~
    * [ ] ~~Keycloak~~
    * [ ] ~~Identity Server~~
    * [x] Auth0
        * [x] Create an API
        * [x] Create Backend Application
        * [x] Create Frontend Application
        * [x] Documentation
* [ ] Health checks dashboard? (Steeltoe)
* [ ] Backend Apis (.NET 7)
    * [ ] Company API
        * [x] Project Setup
        * [x] Logging
        * [x] [Tracing using OpenTelemetry](https://github.com/open-telemetry/opentelemetry-dotnet/blob/main/src/OpenTelemetry.Instrumentation.AspNetCore/README.md)
        * [x] Auth
        * [x] Controllers
        * [x] Health checks
        * [ ] Docker file
        * [ ] Unit Tests
        * [ ] Integration Tests
        * [x] CI/CD
        * [x] Consul Policies
        * [x] Consul Configuration
    * [ ] Project Api
        * [x] Project Setup
        * [x] Logging
        * [x] [Tracing using OpenTelemetry](https://github.com/open-telemetry/opentelemetry-dotnet/blob/main/src/OpenTelemetry.Instrumentation.AspNetCore/README.md)
        * [x] Auth
        * [x] Controllers
        * [x] Health checks
        * [ ] Docker file
        * [ ] Unit Tests
        * [ ] Integration Tests
        * [x] CI/CD
        * [x] Consul Policies
        * [x] Consul Configuration
* [ ] Frontend Application
    * [x] SolidJS App
    * [x] Integration with Auth0
    * [x] Tests
    * [ ] CI/CD
* [ ] Create Deployment Files for K8s
    * [ ] [ELK](https://phoenixnap.com/kb/elasticsearch-kubernetes)

# Getting Started

Before you can begin development, you need to setup the following:

* Auth0
* Consul
* Docker
* DotNET 7 SDK

## Auth0

### Create Backend Application

* Under Applications > Applications, create a new application with the following settings:
    * Name: `Project Management Backend`
    * Application Type: Regular Web Application
    * Allowed Callback URLs: `http://localhost:8012/login/oauth2/code/auth0`
    * Grant Types: Authorization Code, Refresh Token, Implicit, Client Credentials

### Create a Frontend Application

* Under Applications > Applications, create a new application with the following settings:
    * Name: `Project Management Frontend`
    * Application Type: Single Page Application
    * Allowed Callback URLs: `http://localhost:3000`
    * Allowed Logout URLs: `http://localhost:3000`
    * Grant Types: Authorization Code, Refresh Token, Implicit

### Create an API

* Under Applications > APIs, create a new API with the following settings:
    * Name: `Project Management`
    * Identifier: `projectmanagement`
    * Signing Algorithm: `RS256`
* Under Permissions tab of the API, create the following permissions:
    * `read:company`
    * `write:company`
    * `read:project`
    * `write:project`
    * `read:project`
    * `write:project`
    * `update:project`
    * `delete:project`
* Under the Machine to Machine Applications tab, Authorize the Backend Application created above to access the API and
  assign the permissions created above.

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

### Create admin token for Consul Server

Run the following command from powershell:

```powershell
consul.exe acl token create -description "Token for consul-server-1" -node-identity "consul-server-1:az-1" -token="<bootstrap-token>"
```

Reload config `consul.exe reload`

### Setup ACL/KV for each service

* Run the `configure-consul.ps1` script under the `consul` folder for each service.
* Use the generated secret-ids in `appsettings.json` for each service

## Common Issues

### docker-compose fails to start es01

```powershell
wsl -d docker-desktop sysctl -w vm.max_map_count=262144
```
