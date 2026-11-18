# 01 — Split files

Objetivo: mostrar estructura mínima profesional.

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
curl http://localhost:8080
terraform state list
terraform destroy
```

Puntos de explicación:

- Terraform carga todos los `.tf` del directorio como una sola configuración.
- Separar en archivos mejora lectura, no crea namespaces.
- Se agrega una red Docker para mostrar más de un recurso y dependencias.
