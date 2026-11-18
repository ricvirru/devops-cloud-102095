# 02 — Variables, locals y outputs

Objetivo: convertir valores hardcodeados en una interfaz explícita.

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
curl $(terraform output -raw application_url)
terraform destroy
```

Probar override sin editar archivos:

```bash
terraform plan -var='external_port=8090'
terraform apply -var='external_port=8090'
```

Puntos de explicación:

- `variable` = entrada.
- `local` = nombre intermedio calculado.
- `output` = salida útil para humanos, scripts o módulos superiores.
- La validación evita errores antes de tocar infraestructura.
