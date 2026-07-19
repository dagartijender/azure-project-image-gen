# Azure DevOps CI/CD & DevSecOps Pipeline

## Overview

This document describes the Continuous Integration (CI), Continuous Delivery (CD), DevSecOps, and GitOps implementation for the Enterprise AI Platform deployed on Microsoft Azure.

The deployment pipeline automates infrastructure provisioning, application build, security validation, container image creation, and application deployment to Azure Kubernetes Service (AKS).

---

# Solution Overview

The CI/CD workflow integrates Git, Azure DevOps, Terraform, Docker, Helm, Argo CD, Istio, and kgateway to provide a fully automated deployment pipeline.

```
Developer
    │
    ▼
GitHub / Azure Repos
    │
    ▼
Pull Request
    │
    ▼
Code Review
    │
    ▼
Merge to Main
    │
    ▼
Azure DevOps Pipeline
    │
    ├── Terraform
    ├── Build
    ├── Test
    ├── DevSecOps
    ├── Docker
    ├── ACR
    ├── Helm
    └── GitOps
             │
             ▼
         Argo CD
             │
             ▼
Azure Kubernetes Service
             │
             ▼
         kgateway
             │
             ▼
      Istio Service Mesh
             │
             ▼
        AI Application
```

---

# Repository Structure

```
enterprise-ai-platform/

├── application/
│   ├── frontend/
│   ├── backend/
│   └── worker/
│
├── terraform/
│
├── kubernetes/
│
├── helm/
│
├── argocd/
│
├── azure-pipelines/
│   ├── ci.yml
│   ├── cd.yml
│   ├── terraform.yml
│   ├── security.yml
│   └── templates/
│
├── scripts/
│
└── docs/
```

---

# Git Branch Strategy

The project follows a Git Flow branching strategy.

```
main
│
├── develop
│
├── feature/*
│
├── release/*
│
└── hotfix/*
```

| Branch | Purpose |
|---------|----------|
| main | Production |
| develop | Integration |
| feature/* | New Features |
| release/* | Release Preparation |
| hotfix/* | Production Fixes |

---

# Azure DevOps Project

The Azure DevOps project contains the following components.

- Azure Repos
- Azure Pipelines
- Azure Boards
- Azure Artifacts
- Azure Test Plans
- Azure Environments
- Service Connections
- Variable Groups

---

# Azure DevOps Pipeline Stages

## Stage 1 – Source Code

- Checkout Source Code
- Restore Dependencies
- Install Required Tools

---

## Stage 2 – Infrastructure Validation

Terraform validates the Infrastructure as Code before deployment.

Tasks

- Terraform Format
- Terraform Validate
- Terraform Plan

---

## Stage 3 – Infrastructure Deployment

Infrastructure is provisioned using Terraform.

Resources deployed include

- Resource Group
- Virtual Network
- Azure Kubernetes Service
- Azure Container Registry
- Azure Key Vault
- Azure PostgreSQL
- Azure Service Bus
- Azure Blob Storage
- Azure Front Door
- Azure Application Gateway

---

## Stage 4 – Application Build

Application components are compiled.

Applications

- React Frontend
- FastAPI Backend
- Python Worker

---

## Stage 5 – Unit Testing

Quality validation includes

- Unit Tests
- Integration Tests
- Code Coverage

---

# DevSecOps Pipeline

Security validation is integrated directly into the CI pipeline.

| Tool | Purpose |
|------|----------|
| SonarQube | Code Quality & Static Analysis |
| Gitleaks | Secret Detection |
| Black Duck | Software Composition Analysis |
| Veracode | Static Application Security Testing |
| Trivy | Container Image & Kubernetes Security Scan |
| Microsoft Defender for Cloud | Cloud Security Monitoring |

---

# Container Build

Docker images are created for every microservice.

Images

- frontend
- backend
- worker

Each image is tagged with the Azure DevOps Build ID.

Example

```
frontend:$(Build.BuildId)

backend:$(Build.BuildId)

worker:$(Build.BuildId)
```

---

# Azure Container Registry

After successful security validation,

the pipeline

- Authenticates with Azure Container Registry
- Pushes Docker Images
- Creates Versioned Image Tags

---

# Helm Deployment

Helm is used to package Kubernetes resources.

The pipeline performs

- Helm Lint
- Helm Package
- Helm Validation

The packaged charts are stored as Azure DevOps artifacts.

---

# GitOps

The deployment pipeline updates the GitOps repository.

Updated files include

- values.yaml
- image tags
- application configuration

After committing changes,

Argo CD detects the update automatically.

---

# Argo CD Deployment

Argo CD continuously synchronizes the Kubernetes cluster with Git.

Deployment Flow

```
Git Repository

      │

      ▼

Argo CD

      │

      ▼

AKS Cluster

      │

      ▼

kgateway

      │

      ▼

Istio Gateway

      │

      ▼

Application Pods
```

---

# Kubernetes Deployment

Applications are deployed using

- Namespace
- Deployment
- Service
- ConfigMap
- Secret
- Horizontal Pod Autoscaler

Networking resources include

- Gateway
- HTTPRoute
- VirtualService
- DestinationRule

---

# Traffic Flow

```
Internet

      │

      ▼

Azure Front Door

      │

      ▼

Application Gateway

      │

      ▼

kgateway

      │

      ▼

Istio Ingress Gateway

      │

 ┌────┴─────────────┐

 ▼                  ▼

Frontend         Backend

                     │

                     ▼

              Azure Service Bus

                     │

                     ▼

                 Worker Service

                     │

      ┌──────────────┼──────────────┐

      ▼              ▼              ▼

Azure OpenAI   Blob Storage   PostgreSQL
```

---

# Monitoring

The platform is monitored using

- Azure Monitor
- Log Analytics
- Prometheus
- Grafana
- Istio Telemetry

---

# Azure DevOps Service Connections

Create the following service connections.

- Azure Resource Manager
- Azure Kubernetes Service
- Azure Container Registry
- GitHub or Azure Repos
- SonarQube
- Veracode
- Black Duck

---

# Azure DevOps Variable Groups

Store configuration in Variable Groups.

Example variables

- RESOURCE_GROUP
- AKS_CLUSTER
- ACR_NAME
- STORAGE_ACCOUNT
- POSTGRES_SERVER
- SERVICE_BUS_NAMESPACE
- OPENAI_ENDPOINT
- OPENAI_DEPLOYMENT

Sensitive values should be stored in Azure Key Vault and linked to Azure DevOps.

---

# Deployment Workflow

1. Developer pushes code to a feature branch.
2. A Pull Request is created.
3. Code review and approval are completed.
4. Changes are merged into the **main** branch.
5. Azure DevOps automatically starts the CI pipeline.
6. Terraform validates and deploys Azure infrastructure.
7. Application code is compiled and tested.
8. DevSecOps tools scan source code, dependencies, and container images.
9. Docker images are pushed to Azure Container Registry.
10. Helm charts are packaged.
11. The GitOps repository is updated.
12. Argo CD synchronizes the changes to Azure Kubernetes Service.
13. Traffic is routed through Azure Front Door, Application Gateway, kgateway, and Istio.
14. Azure Monitor, Prometheus, and Grafana continuously monitor the platform.

---

# Benefits

- Fully automated infrastructure provisioning
- Infrastructure as Code using Terraform
- Enterprise CI/CD with Azure DevOps
- Integrated DevSecOps security scanning
- GitOps deployment using Argo CD
- Secure secrets using Azure Key Vault
- Kubernetes Gateway API using kgateway
- Service Mesh using Istio
- Production-ready deployment strategy
- Scalable AI platform on Microsoft Azure
