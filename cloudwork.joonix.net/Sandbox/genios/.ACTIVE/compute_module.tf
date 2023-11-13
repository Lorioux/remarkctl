

module "compute" {

  source = "./compute"

  google_compute_instance = {
    names    = ["instance-2", ]
    argsfile = "${path.cwd}/.BASE/.instance"
  }
}

