# Variables vs. Outputs in Terraform Modules

Variables and outputs are opposite ends of a module's interface:

- **Variables** = data flowing **in** (inputs / parameters)
- **Outputs**  = data flowing **out** (results / return values)

This doc walks through the real files in `06-modules/` to show how data
moves from the root module, into the child module, and back out again.

## The files involved

```
06-modules/
├── variables.tf              (root inputs)
├── main.tf                   (calls the module)
├── outputs.tf                (re-exposes module outputs)
└── modules/web_service/
    ├── variables.tf          (module's parameter list)
    ├── main.tf               (builds resources)
    └── outputs.tf            (module's return values)
```

## Step by step

**1. Root `variables.tf`** — inputs to the whole config

```hcl
variable "project_name"  { default = "tf-module-demo" }
variable "external_port" { default = 8080 }
```

**2. Root `main.tf`** — calling the module, passing values down

```hcl
module "web_service" {
  source        = "./modules/web_service"
  project_name  = var.project_name      # root variable -> child variable
  image_name    = "nginx:alpine"        # hardcoded value -> child variable
  external_port = var.external_port     # root variable -> child variable
}
```

**3. Child `modules/web_service/variables.tf`** — the module's parameter list

```hcl
variable "project_name"  { type = string }
variable "image_name"    { type = string }
variable "external_port" { type = number }
```

No defaults — the caller (step 2) *must* supply them.

**4. Child `main.tf`** — the module does its work using those variables

```hcl
resource "docker_container" "web" {
  name  = local.container_name          # "tf-module-demo-web"
  ports { external = var.external_port } # 8080
  ...
}
```

**5. Child `outputs.tf`** — the module hands a result back up

```hcl
output "application_url" {
  value = "http://localhost:${var.external_port}"
}
output "container_name" {
  value = docker_container.web.name
}
```

Outside the module, these are addressed as `module.web_service.application_url`.

**6. Root `outputs.tf`** — re-exposing the module's return value

```hcl
output "application_url" {
  value = module.web_service.application_url   # pulls the child's output
}
```

This exposes it at the root level, so `terraform apply` prints it in the terminal.

## Data flow diagram

```
                         VARIABLES FLOW DOWN
                                 |
  +----------------------------------------------------------+
  |  ROOT MODULE (06-modules/)                                |
  |                                                            |
  |  variables.tf                                              |
  |  var.project_name  = "tf-module-demo"  ---+                |
  |  var.external_port = 8080              ---+                |
  |                                          | |                |
  |                                          v v                |
  |  main.tf                                                   |
  |  module "web_service" {                                    |
  |    project_name  = var.project_name    ----+                |
  |    image_name    = "nginx:alpine"      ----+                |
  |    external_port = var.external_port   ----+                |
  |  }                                          |                |
  +----------------------------------------------|---------------+
                                                  |
                                                  v
  +----------------------------------------------------------+
  |  CHILD MODULE (modules/web_service/)                       |
  |                                                            |
  |  variables.tf                                              |
  |  var.project_name   <----+                                 |
  |  var.image_name     <----+                                 |
  |  var.external_port  <----+                                 |
  |         |                                                  |
  |         v                                                  |
  |  main.tf                                                   |
  |  resource "docker_container" "web" {                       |
  |    name  = local.container_name                            |
  |    ports { external = var.external_port }                  |
  |  }                                                          |
  |         |                                                  |
  |         v                                                  |
  |  outputs.tf                                                |
  |  output "application_url" {                                |
  |    value = "http://localhost:${var.external_port}"  ---+   |
  |  }                                                       |   |
  |  output "container_name" {                                |
  |    value = docker_container.web.name                 ---+|   |
  |  }                                                     | |   |
  +---------------------------------------------------------|-|--+
                                                              | |
                              OUTPUTS FLOW UP                | |
                                                              v v
  +----------------------------------------------------------+
  |  ROOT MODULE (06-modules/)                                |
  |                                                            |
  |  outputs.tf                                                |
  |  output "application_url" {                                |
  |    value = module.web_service.application_url  <-----------+
  |  }                                                          |
  |  output "container_name" {                                  |
  |    value = module.web_service.container_name    <-----------+
  |  }                                                          |
  +----------------------------------------------------------+
                                 |
                                 v
                    printed by `terraform apply`
                 application_url = "http://localhost:8080"
                 container_name  = "tf-module-demo-web"
```

## Takeaway

| | Variables | Outputs |
|---|---|---|
| Direction | Flow **down** (root -> module -> resource) | Flow **up** (resource -> module -> root -> CLI) |
| Purpose | Configure things *before* they're built | Report on things *after* they're built |
| Analogy | Function parameters | Function return values |
| Used for wiring modules | Receive a value from a caller | Hand a value to a caller, or to another module (`module.a.output_x` as input to module B) |
