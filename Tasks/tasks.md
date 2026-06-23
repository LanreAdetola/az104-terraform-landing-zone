# AZ-104 Terraform Project: Azure Landing Zone — Task Checklist

Project: Hub-and-spoke landing zone with multi-environment (dev/prod) support, Terraform-managed, using a free-tier Cosmos DB account (Core/SQL API) with Azure AD-only authentication.

---

## Phase 1: Local Environment Setup

- [x] 1.1 Install Terraform (`terraform version` works)
- [x] 1.2 Install Azure CLI (`az version` works)
- [x] 1.3 Authenticate to Azure (`az login`)
- [x] 1.4 Create resource group for Terraform state (`tfstate-rg`)
- [x] 1.5 Create storage account for state (`tfstate...`)
- [x] 1.6 Create storage container for state (`tfstate`)
- [x] 1.7 Verify setup (`terraform version` + `az account show`)

---

## Phase 2: Project Structure

### Root-level files
- [x] 2.1 Create root project folder (`az104-landing-zone`)
- [x] 2.2 Create `providers.tf`
- [x] 2.3 Create `backend.tf`
- [x] 2.4 Create root `variables.tf`
- [x] 2.5 Create root `main.tf`
- [x] 2.6 Create root `outputs.tf`
- [x] 2.7 Create `.gitignore`

### Networking module
- [x] 2.8 Create `modules/` folder
- [x] 2.9 Create `modules/networking/` folder
- [x] 2.10 Create `modules/networking/variables.tf`
- [x] 2.11 Create `modules/networking/main.tf`
  - [x] Resource group
  - [x] Hub VNet
  - [x] Spoke VNet
  - [x] Subnets (frontend / backend / data)
  - [x] NSGs + rules
  - [x] VNet peering (hub ↔ spoke)
- [x] 2.12 Create `modules/networking/outputs.tf`

### Compute module
- [x] 2.13 Create `modules/compute/` folder
- [x] 2.14 Create `modules/compute/variables.tf`
- [x] 2.15 Create `modules/compute/main.tf`
  - [x] App Service Plan
  - [x] Front-end App Service
  - [x] Backend App Service
  - [x] Managed Identity wiring
  - [x] Key Vault access policy
- [x] 2.16 Create `modules/compute/outputs.tf`

### Database module
- [x] 2.17 Create `modules/database/` folder
- [x] 2.18 Create `modules/database/variables.tf`
- [x] 2.19 Create `modules/database/main.tf`
  - [x] Cosmos DB account (Core/SQL API, free tier)
  - [x] Azure AD-only authentication (local auth disabled)
  - [x] Continuous backup policy
- [x] 2.20 Create `modules/database/outputs.tf`

### Governance module
- [x] 2.21 Create `modules/governance/` folder
- [x] 2.22 Create `modules/governance/variables.tf`
- [x] 2.23 Create `modules/governance/main.tf`
  - [x] Azure Policy: require environment tag
  - [x] Azure Policy: allowed locations
  - [ ] Custom RBAC role definitions *(scoped out — policy-only governance deemed sufficient for this project)*
- [x] 2.24 Create `modules/governance/outputs.tf`

### Environment variable files
- [x] 2.25 Create `dev.tfvars`
- [ ] 2.26 Create `prod.tfvars`

---

## Phase 3: Wire Up the Root Module

- [x] 3.1 Call networking module from root `main.tf`
- [x] 3.2 Call compute module, passing networking outputs
- [x] 3.3 Call database module
- [x] 3.4 Call governance module
- [x] 3.5 Define root-level outputs (App Service URLs, Cosmos DB endpoint, Key Vault URI)

---

## Phase 4: Validate & Deploy

- [x] 4.1 `terraform init`
- [x] 4.2 `terraform validate`
- [x] 4.3 `terraform plan -var-file="dev.tfvars"` — clean across all 4 modules
- [x] 4.4 `terraform apply -var-file="dev.tfvars"` — networking only
- [x] 4.5 Verify resources in Azure Portal — networking confirmed (VNets, NSGs, peering)
- [ ] 4.6 Apply and verify compute, database, governance live
- [ ] 4.7 Repeat plan/apply with `prod.tfvars`
- [x] 4.8 Confirm free-tier limits respected (App Service B1, Cosmos DB free tier)

---

## Phase 5: Documentation & Portfolio Polish

- [ ] 5.1 Write architecture diagram (hub-spoke, tiers, identity flow)
- [x] 5.2 Write README with deployment instructions
- [x] 5.3 Document module inputs/outputs
- [x] 5.4 Push to GitHub
- [ ] 5.5 Add to CV / portfolio project list

---

## Notes
- Database: Cosmos DB (Core/SQL API), free tier, Azure AD-only auth — no connection strings or keys used anywhere in the project.
- Keep `*.tfvars` and `*.tfstate` out of Git (see `.gitignore`).
- Learning approach: write code first, review/debug together, then iterate.
- Cost discipline: compute (B1 App Service Plan) only applied when actively testing, destroyed afterward to avoid ongoing charges.