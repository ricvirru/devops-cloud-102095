# 06 — Modules

Objetivo: mostrar cómo encapsular recursos y exponer una interfaz.

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform output
curl $(terraform output -raw application_url)
terraform destroy
```

Puntos de explicación:

- Todo directorio Terraform es un root module.
- Un módulo hijo agrupa recursos reutilizables.
- Variables = inputs del módulo.
- Outputs = contrato de salida del módulo.
- En equipos reales, los módulos permiten estandarizar patrones.
