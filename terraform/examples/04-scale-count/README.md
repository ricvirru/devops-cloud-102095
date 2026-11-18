# 04 — Scale with count

Objetivo: mostrar metaprogramación mínima con `count` sin meterse todavía en módulos complejos.

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
curl http://localhost:8080
curl http://localhost:8081
```

Cambiar número de réplicas sin editar archivos:

```bash
terraform plan -var='replicas=3'
terraform apply -var='replicas=3'
terraform output
curl http://localhost:8082
terraform destroy
```

Puntos de explicación:

- `count` crea múltiples instancias indexadas.
- Las direcciones quedan como `docker_container.web[0]`, `docker_container.web[1]`.
- En producción conviene evaluar `for_each` cuando las instancias tienen identidad estable.
