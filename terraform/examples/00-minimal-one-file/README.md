# 00 — Minimal one-file demo

Objetivo: mostrar que Terraform puede crear infraestructura local usando Docker.

```bash
terraform init
terraform fmt
terraform plan
terraform validate
terraform apply
curl http://localhost:8080
terraform show
terraform state list
terraform destroy
```

Puntos de explicación:

- `terraform {}` define requisitos de versión y providers.
- `provider "docker" {}` configura el plugin.
- `docker_image` y `docker_container` son recursos.
- `image = docker_image.nginx.image_id` crea una dependencia implícita.
