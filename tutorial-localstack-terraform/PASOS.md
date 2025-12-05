````markdown
# Terraform + LocalStack - Entorno Local Paso a Paso

Este tutorial muestra cómo probar **Terraform con LocalStack**, simulando servicios AWS completamente local y gratis.

---

## 1. Instalar Docker

LocalStack corre dentro de Docker. Verifica que Docker esté instalado:

```bash
docker --version
````

---

## 2. Ejecutar LocalStack

Descarga y ejecuta LocalStack con Docker:

```bash
docker run --rm -it -p 4566:4566 -p 4571:4571 localstack/localstack
```

* `4566` → puerto principal de LocalStack (servicios AWS).
* `4571` → puerto adicional opcional.
* LocalStack iniciará un entorno simulado de AWS.

---

## 3. Crear proyecto Terraform

Crea una carpeta, por ejemplo `localstack-demo`, y un archivo `main.tf` con el siguiente contenido:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  access_key = "test"
  secret_key = "test"
  region     = "us-east-1"

  endpoints {
    s3 = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "mi-bucket-localstack"
  acl    = "private"
}

output "bucket_name" {
  value = aws_s3_bucket.demo_bucket.id
}
```

### Conceptos clave

* `provider "aws"` → Terraform usa AWS, pero apuntando a LocalStack.
* `endpoints` → fuerza que S3 sea local.
* `aws_s3_bucket` → crea un bucket S3 simulado.
* `output` → muestra información al final.

---

## 4. Inicializar Terraform

Desde la carpeta del proyecto:

```bash
terraform init
```

Esto descarga el proveedor AWS.

---

## 5. Ver plan de Terraform

```bash
terraform plan
```

Muestra qué recursos se van a crear.

---

## 6. Aplicar Terraform

```bash
terraform apply
```

Confirma con `yes`. Se crea el bucket en LocalStack.

---

## 7. Verificar bucket

Usa AWS CLI apuntando a LocalStack:

```bash
aws --endpoint-url=http://localhost:4566 s3 ls
```

Deberías ver `mi-bucket-localstack`.

---

## 8. Limpiar recursos

```bash
terraform destroy
```

Borra todo lo creado.

---

Con esto tienes un entorno local simulado de AWS, listo para practicar Terraform sin pagar nada.

```
```
