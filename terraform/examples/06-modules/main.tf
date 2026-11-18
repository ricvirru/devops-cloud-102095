module "web_service" {
  source = "./modules/web_service"

  project_name  = var.project_name
  image_name    = "nginx:alpine"
  external_port = var.external_port
}
