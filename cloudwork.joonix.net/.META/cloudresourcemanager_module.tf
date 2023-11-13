

module "cloudresourcemanager" {

  source = "./cloudresourcemanager"

  google_project = {
    names    = ["macro-gadget-384911", "azure-lab-382116", "cw-prod-audit-logs-000", "cw-prod-iac-core-000", "cw-prod-billing-exp-000", "onboarding-host-9aaffdb8ae154f", ]
    argsfile = "${path.cwd}/.BASE/.project"
  }
}

