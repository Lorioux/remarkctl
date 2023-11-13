

module "compute" {

  source = "./compute"

  google_compute_instance = {
    names    = ["server-labs", "instance-2", "instance-1", "instance-5", "instance-4", "k8s-terminal", "worker", ]
    argsfile = "${path.cwd}/.BASE/.instance"
  }
}

