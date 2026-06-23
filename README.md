# AZ-104 Terraform Project: Azure Landing Zone

A hub-and-spoke Azure landing zone built with Terraform, designed to apply AZ-104 concepts hands-on while building toward Terraform/DevOps proficiency. Supports multi-environment (dev/prod) deployment using a modular structure, fully parameterized via `.tfvars` files.

## Architecture

- **Hub-and-spoke network topology**: central hub VNet with shared services, spoke VNets per environment, connected via VNet peering.
- **Network segmentation**: dedicated subnets (frontend, backend, data) per spoke, each governed by its own NSG with explicit allow/deny rules.
- **Three-tier application pattern**: frontend → backend → database, with traffic restricted tier-to-tier (e.g. only backend can reach the data subnet, only on port 1433).
- **Identity-first design**: Managed Identities for app authentication, no stored credentials or connection strings. Secrets pulled from Key Vault at runtime.
- **Cosmos DB (Core/SQL API)**: free-tier Cosmos DB account with Azure AD-only authentication (local/key-based auth disabled), continuous backup, and a throughput cap to control cost.
- **Governance via Azure Policy**: built-in policy assignments enforcing required tags and restricting deployments to a single approved region.

## Status

✅ **Networking module** — complete, deployed, and verified (resource group, hub VNet, spoke VNet, subnets, NSGs, NSG rules, peering)
✅ **Compute module** — complete and validated (`terraform plan` clean); App Service Plan, frontend/backend App Services, Managed Identities, VNet integration, Key Vault access policies. Not yet applied (cost-conscious — B1 tier is billed hourly).
✅ **Database module** — complete and validated; Cosmos DB account (Core/SQL API), free tier, AD-only auth. Not yet applied.
✅ **Governance module** — complete and validated; Azure Policy assignments for tag enforcement and allowed locations. Not yet applied.

All four modules pass `terraform plan` cleanly with no errors. Networking is the only module currently deployed live; the rest are infrastructure-as-code, ready to deploy on demand.

See [`Tasks/tasks.md`](./Tasks/tasks.md) for the full build checklist.

## Structure

az104-landing-zone/

├── main.tf            # Root module — orchestrates all child modules

├── variables.tf       # Root-level input variables

├── outputs.tf         # Root-level outputs (frontend/backend URLs, Cosmos DB endpoint, Key Vault URI)

├── providers.tf       # Provider configuration (azurerm, random)

├── backend.tf         # Remote state configuration (Azure Storage)

├── dev.tfvars         # Environment-specific values (gitignored)

├── modules/

│   ├── networking/    # VNets, subnets, NSGs, peering

│   ├── compute/       # App Services, Managed Identities, Key Vault access

│   ├── database/      # Cosmos DB account (Core/SQL API, free tier)

│   └── governance/    # Azure Policy assignments

└── Tasks/

└── tasks.md       # Build checklist


## Why this project

Built as a hands-on companion to AZ-104 exam prep, with a deliberate focus on Terraform — currently the most consequential gap for Azure DevOps/Cloud Engineer roles. The goal is a portfolio piece that demonstrates platform engineering thinking: governance, segmentation, identity, and reproducible infrastructure-as-code, not just individual resource deployment. The project evolved during development — most notably switching the database tier from Azure SQL to Cosmos DB after running into the per-subscription free-tier SQL constraint, in favor of an architecture using Azure AD-only authentication (no connection strings at all).

## Known simplifications

A few deliberate trade-offs were made to keep this project free-tier-friendly and learning-focused, worth noting for anyone reviewing the code:

- App Services are reachable via their public `azurewebsites.net` URLs regardless of NSG rules — VNet integration here controls *outbound* traffic from the apps, not inbound. Real production setups would add Private Endpoints or Access Restrictions for inbound control.
- Key Vault and Cosmos DB both have `public_network_access_enabled = true`. Production environments would typically use Private Endpoints instead.
- No CI/CD pipeline is wired up yet — this is infrastructure-only; application code deployment is a separate, later concern.

## Requirements

- Terraform >= 1.0
- Azure CLI, authenticated (`az login`)
- An Azure subscription (free tier compatible)

## Usage

```bash
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

Note: `dev.tfvars` and `prod.tfvars` are gitignored (not included in this repo) since they contain environment-specific values, including networking ranges and NSG rule definitions. Create your own `.tfvars` file based on the variables declared in root `variables.tf`.