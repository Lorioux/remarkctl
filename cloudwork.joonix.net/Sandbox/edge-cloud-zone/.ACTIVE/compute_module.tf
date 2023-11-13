

module "compute" {

  source = "./compute"

  google_compute_instance = {
    names    = ["apigee-proxy-kw8k", "apigee-proxy-7r5x", ]
    argsfile = "${path.cwd}/.BASE/.instance"
  }
}

