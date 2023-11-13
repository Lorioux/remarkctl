

module "cloudresourcemanager" {

  source = "./cloudresourcemanager"

  google_project = {
    names    = ["cw-dev-sec-core-000", ]
    argsfile = "${path.cwd}/.BASE/.project"
  }
}

