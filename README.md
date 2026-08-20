# Port Terraform Project

Proyecto Terraform **orientado a módulos** para gestionar el data model de
[Port](https://www.port.io como código,
desplegado vía GitHub Actions.

## Estructura

```
.
├── .github/workflows/port-terraform.yml   # Pipeline CI/CD (plan en PR, apply en main/dispatch)
├── modules/
│   ├── blueprint/     # Módulo genérico para crear blueprints
│   ├── entity/         # Módulo genérico para crear entidades
│   └── scorecard/      # Módulo genérico para crear scorecards
└── environments/
    ├── dev/             # Composición de módulos para el ambiente dev
    └── prod/            # Composición de módulos para el ambiente prod
```

Cada ambiente (`environments/<env>`) es la raíz de Terraform (root module) que
**instancia** los módulos reutilizables de `modules/`. Esto permite:

- Definir un blueprint una sola vez (en `modules/blueprint`) y reutilizarlo
  con distintos parámetros en `dev` y `prod`.
- Versionar cambios de estructura del catálogo de forma independiente del
  entorno donde se aplican.
- Escalar agregando nuevos módulos (`action`, `automation`, etc.) sin tocar
  los ambientes existentes.

## Requisitos

- Terraform >= 1.5
- Credenciales de Port (Client ID / Client Secret) — Settings → Credentials
  en tu portal de Port.

## Uso local

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars   # y completa tus credenciales
terraform init
terraform plan
terraform apply
```

> `terraform.tfvars` está en `.gitignore`: nunca subas credenciales reales al repo.

## CI/CD (GitHub Actions)

El workflow `.github/workflows/port-terraform.yml`:

1. **Pull Request** → corre `terraform plan` en matrix para `dev` y `prod`,
   y comenta el resultado en el PR.
2. **Push a `main`** → aplica automáticamente sobre `dev`.
3. **`workflow_dispatch`** (manual) → permite elegir `dev` o `prod` y aplicar
   bajo un [GitHub Environment](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
   con reviewers obligatorios (recomendado para `prod`).

### Secrets requeridos

En **Settings → Secrets and variables → Actions**:

| Secret                | Descripción                        |
|------------------------|-------------------------------------|
| `PORT_CLIENT_ID`       | Client ID de Port                  |
| `PORT_CLIENT_SECRET`   | Client Secret de Port              |

### (Opcional) Backend remoto de state

Por defecto el ejemplo usa state local, útil solo para probar. Para CI/CD real,
descomenta el bloque `backend` en `environments/<env>/versions.tf` y apunta a
S3, Azure Storage o el backend que uses, pasando las credenciales también
como secrets del pipeline.

## Blueprint de ejemplo incluido

El ambiente `dev` despliega, a modo de ejemplo, dos blueprints relacionados:

- **`environment`** — representa un ambiente de infraestructura (dev/staging/prod)
- **`service`** — representa un servicio de software, relacionado 1:1 con `environment`

y dos entidades de ejemplo (`dev` y `example-service`) para verificar que el
pipeline efectivamente pobló el catálogo.

## Agregar un nuevo blueprint

1. Añade un bloque `module "mi_blueprint" { source = "../../modules/blueprint" ... }`
   en `environments/<env>/main.tf`.
2. Corre `terraform plan` localmente o abre un PR para ver el plan en CI.
3. Al mergear a `main`, el pipeline aplica el cambio automáticamente en `dev`.
