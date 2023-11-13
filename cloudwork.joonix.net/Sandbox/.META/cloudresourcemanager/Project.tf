
locals {
  google_project = jsondecode(file("${var.google_project["argsfile"]}")) #["resources"][0]
  project_attrs  = { for instance in local.google_project.instances : ("${instance["index_key"]}") => ("${instance["attributes"]}") }
}

variable "google_project" {
  type = object({
    names    = list(string)
    argsfile = string
  })
}

resource "google_project" "project" {
  for_each = { for attributes in local.project_attrs : ("${attributes["name"]}") => attributes
  if contains(distinct(var.google_project["names"]), "${attributes["name"]}") && "${attributes["name"]}" != "" }
  # required fields

  project_id = each.value["project_id"]

  number = each.value["number"]

  skip_delete = each.value["skip_delete"]

  name = each.value["name"]

}

