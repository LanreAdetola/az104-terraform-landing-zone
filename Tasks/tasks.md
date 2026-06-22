# AZ-104 Terraform Project: Azure Landing Zone — Task Checklist

Project: Hub-and-spoke landing zone with multi-environment (dev/prod) support, Terraform-managed, built on existing free-tier Azure SQL Server.

---

## Phase 1: Local Environment Setup

- [ ] 1.1 Install Terraform (`terraform version` works)
- [ ] 1.2 Install Azure CLI (`az version` works)
- [ ] 1.3 Authenticate to Azure (`az login`)
- [ ] 1.4 Create resource group for Terraform state (`tfstate-rg`)
- [ ] 1.5 Create storage account for state (`tfstate...`)
- [ ] 1.6 Create storage container for state (`tfstate`)
- [ ] 1.7 Verify setup (`terraform version` + `az account show`)

---

## Phase 2: Project Structure

### Root-level files
- [ ] 2.1 Create root project folder (`az104-landing-zone`)
- [ ] 2.2 Create `providers.tf`
- [ ] 2.3 Create `backend.tf`
- [ ] 2.4 Create root `variables.tf`
- [ ] 2.5 Create root `main.tf`
- [ ] 2.6 Create root `outputs.tf`
- [ ] 2.7 Create `.gitignore`

### Networking module
- [ ] 2.8 Create `modules/` folder
- [ ] 2.9 Create `modules/networking/` folder
- [ ] 2.10 Create `modules/networking/variables.tf`
- [ ] 2.11 Create `modules/networking/main.tf`
  - [ ] Resource group
  - [ ] Hub VNet
  - [ ] Spoke VNet
  - [ ] Subnets (frontend / backend / data)
  - [ ] NSGs + rules
  - [ ] VNet peering (hub ↔ spoke)
- [ ] 2.12 Create `modules/networking/outputs.tf`

### Compute module
- [ ] 2.13 Create `modules/compute/` folder
- [ ] 2.14 Create `modules/compute/variables.tf`
- [ ] 2.15 Create `modules/compute/main.tf`
  - [ ] App Service Plan
  - [ ] Front-end App Service
  - [ ] Backend App Service
  - [ ] Managed Identity wiring
  - [ ] Key Vault access policy/role assignment
- [ ] 2.16 Create `modules/compute/outputs.tf`

### Database module
- [ ] 2.17 Create `modules/database/` folder
- [ ] 2.18 Create `modules/database/variables.tf`
- [ ] 2.19 Create `modules/database/main.tf`
  - [ ] Data source: reference existing Azure SQL Server
  - [ ] `azurerm_mssql_database` (dev)
  - [ ] `azurerm_mssql_database` (prod)
  - [ ] Firewall rules
- [ ] 2.20 Create `modules/database/outputs.tf`

### Governance module
- [ ] 2.21 Create `modules/governance/` folder
- [ ] 2.22 Create `modules/governance/variables.tf`
- [ ] 2.23 Create `modules/governance/main.tf`
  - [ ] Azure Policy definitions/assignments (tagging, encryption, naming)
  - [ ] Custom RBAC role definitions
  - [ ] Role assignments per environment
- [ ] 2.24 Create `modules/governance/outputs.tf`

### Environment variable files
- [ ] 2.25 Create `dev.tfvars`
- [ ] 2.26 Create `prod.tfvars`

---

## Phase 3: Wire Up the Root Module

- [ ] 3.1 Call networking module from root `main.tf`
- [ ] 3.2 Call compute module, passing networking outputs
- [ ] 3.3 Call database module, referencing existing SQL Server
- [ ] 3.4 Call governance module
- [ ] 3.5 Define root-level outputs (App Service URLs, DB connection info, etc.)

---

## Phase 4: Validate & Deploy

- [ ] 4.1 `terraform init`
- [ ] 4.2 `terraform validate`
- [ ] 4.3 `terraform plan -var-file="dev.tfvars"`
- [ ] 4.4 `terraform apply -var-file="dev.tfvars"`
- [ ] 4.5 Verify resources in Azure Portal
- [ ] 4.6 Repeat plan/apply with `prod.tfvars`
- [ ] 4.7 Confirm free-tier limits respected (App Service, SQL databases)

---

## Phase 5: Documentation & Portfolio Polish

- [ ] 5.1 Write architecture diagram (hub-spoke, tiers, identity flow)
- [ ] 5.2 Write README with deployment instructions
- [ ] 5.3 Document module inputs/outputs
- [ ] 5.4 Push to GitHub
- [ ] 5.5 Add to CV / portfolio project list

---

## Notes
- Database: building on existing free-tier Azure SQL Server (1 server, up to 10 databases) — referenced via `data` block, not recreated.
- Keep `*.tfvars` and `*.tfstate` out of Git (see `.gitignore`).
- Learning approach: write code first, review/debug together, then iterate.
