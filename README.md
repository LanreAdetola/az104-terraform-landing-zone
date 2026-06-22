# AZ-104 Terraform Project: Azure Landing Zone

A hub-and-spoke Azure landing zone built with Terraform, designed to apply AZ-104 concepts hands-on while building toward Terraform/DevOps proficiency. Supports multi-environment (dev/prod) deployment using a modular structure.

## Architecture

- **Hub-and-spoke network topology**: central hub VNet with shared services, spoke VNets per environment, connected via VNet peering.
- **Network segmentation**: dedicated subnets (frontend, backend, data) per spoke, each governed by its own NSG with explicit allow/deny rules.
- **Three-tier application pattern**: frontend → backend → database, with traffic restricted tier-to-tier (e.g. only backend can reach the data subnet, only on port 1433).
- **Identity-first design**: Managed Identities for app authentication, no stored credentials or connection strings.
- **Existing Azure SQL Server**: databases are provisioned within an already-running free-tier SQL Server (referenced via Terraform data source, not recreated), staying within the free-tier limit of 10 databases per server.

## Status

✅ **Networking module** — complete and deployed (resource group, hub VNet, spoke VNet, subnets, NSGs, NSG rules, peering)
🚧 **Compute module** — in progress (App Services, Managed Identities, Key Vault integration)
⬜ **Database module** — planned
⬜ **Governance module** — planned (Azure Policy, custom RBAC)

See [`Tasks/tasks.md`](./Tasks/tasks.md) for the full build checklist.

## Structure

az104-landing-zone/

├── main.tf            # Root module — orchestrates all child modules

├── variables.tf       # Root-level input variables

├── outputs.tf         # Root-level outputs

├── providers.tf       # Provider configuration (azurerm)

├── backend.tf         # Remote state configuration (Azure Storage)

├── modules/

│   ├── networking/    # VNets, subnets, NSGs, peering

│   ├── compute/       # App Services, Managed Identities

│   ├── database/      # Azure SQL databases (existing server)

│   └── governance/    # Azure Policy, RBAC

└── Tasks/

└── tasks.md       # Build checklist

## Why this project

Built as a hands-on companion to AZ-104 exam prep, with a deliberate focus on Terraform — currently the most consequential gap for Azure DevOps/Cloud Engineer roles. The goal is a portfolio piece that demonstrates platform engineering thinking: governance, segmentation, identity, and reproducible infrastructure-as-code, not just individual resource deployment.

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

Note: `dev.tfvars` and `prod.tfvars` are gitignored (not included in this repo) since they may contain environment-specific values. Create your own based on the variables defined in each module.