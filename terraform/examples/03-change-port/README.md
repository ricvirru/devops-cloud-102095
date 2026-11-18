# 03 — Cambio controlado: puerto 8080 → 9090

Objetivo: mostrar cómo Terraform detecta una diferencia entre configuración y estado actual.

Secuencia recomendada:

1. Venir desde `02-variables-outputs` con recursos aplicados.
2. Comparar `variables.tf` entre carpetas.
3. Ejecutar:

```bash
terraform init
terraform plan
terraform apply
curl http://localhost:9090
terraform destroy
```

Puntos de explicación:

- El plan muestra qué va a cambiar antes de tocar nada.
- Algunos cambios son update in-place, otros fuerzan reemplazo.
- El provider decide qué atributos requieren recrear el recurso.
