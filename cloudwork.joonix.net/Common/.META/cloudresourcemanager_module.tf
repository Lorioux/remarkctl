

module "cloudresourcemanager" {

  source = "./cloudresourcemanager"

  google_project = {
    names    = ["monitoring-dev-ed741-hs351", "logging-ed741-hs351", "monitoring-nonprod-ed741-hs351", "monitoring-prod-ed741-hs351", ]
    argsfile = "${path.cwd}/.BASE/.project"
  }
}

