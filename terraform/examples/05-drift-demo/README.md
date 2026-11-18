# 05 — Drift demo

Objetivo: demostrar qué pasa cuando alguien toca infraestructura fuera de Terraform.

```bash
terraform init
terraform apply
terraform output
```

Ahora romper manualmente el mundo real:

```bash
docker rm -f tf-demo-web
```

Terraform detecta el drift:

```bash
terraform plan
terraform apply
terraform output
curl $(terraform output -raw application_url)
terraform destroy
```

Puntos de explicación:

- El state dice que el contenedor existe.
- Docker dice que ya no existe.
- El plan propone recrearlo para volver al estado deseado.
- Esta es una de las razones por las que se evita tocar infraestructura manualmente.
