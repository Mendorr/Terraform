// 1. Archivo de configuración
// ANTES INSTALA EL PLUGIN DE TU IDE PARA TERRAFORM
// terraform.tf configura Terraform. Versiones, credenciales, proveedores y plugins a instalar...

// 1.1 PROVEEDOR
terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "~> 4.0"
    }
  }
}

// 1.2 CONFIGURACIÓN
provider "oci" {
  tenancy_ocid     = ""
  user_ocid        = ""
  fingerprint      = ""
  private_key_path = ""
  region           = ""
}
# provider "oci" {
#   tenancy_ocid     = var.tenancy_ocid
#   user_ocid        = var.user_ocid
#   fingerprint      = var.fingerprint
#   private_key_path = var.key_file
#   region           = var.region
# }
