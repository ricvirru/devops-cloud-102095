# 07 — Fallback no Docker

Objetivo: poder enseñar plan, apply, state, outputs y replacement aunque Docker o internet fallen.

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
terraform show
terraform state list
```

Mostrar replacement:

```bash
terraform plan -var='version=v2'
terraform apply -var='version=v2'
terraform destroy
```

Puntos de explicación:

- `terraform_data` no administra infraestructura externa.
- Sirve como fallback didáctico para mostrar ciclo de vida.
- No reemplaza una demo real de provider, pero salva la clase si Docker falla.
