resource "terraform_data" "deployment" {
  input = {
    project_name = var.project_name
    version      = var.version
    description  = "Recurso local sin provider externo"
  }

  triggers_replace = [var.version]
}
