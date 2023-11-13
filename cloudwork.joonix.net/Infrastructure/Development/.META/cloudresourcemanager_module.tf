

module "cloudresourcemanager" {

  source = "./cloudresourcemanager"

  google_project = {
    names    = ["cw-dev-net-spoke-000", ]
    argsfile = "${path.cwd}/.BASE/.project"
  }
}

