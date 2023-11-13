

module "cloudresourcemanager" {

  source = "./cloudresourcemanager"

  google_project = {
    names    = ["services-362613", "edge-cloud-zone", "notino-poc-gcve", "genios-371611", "devops-studio-359213", "cloudlabs-371516", "funtalk-379111", ]
    argsfile = "${path.cwd}/.BASE/.project"
  }
}

