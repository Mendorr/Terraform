// 2. Configuración de proveedores y otros recursos
// main.tf es el archivo recomendado por HashiCorp para configurar recursos

// Con el comando
// $ terraform fmt
// se formatea el código con el etilo recomendado.


// Con el comando:
// -----------------------
//   $ terraform validate
// -----------------------
// Se comprueba que no haya errores y que la configuración es válida

// Con el comando:
// -----------------------
//   $ terraform init
// -----------------------
// Se inicializa la configuración.
// Se descargan proveedores en una carpeta .terraform y recursos del registro oficial.
// Se crean

// Con el comando:
// -----------------------
//   $ terraform apply
// -----------------------
// Se crea el plan de ejecución.
// Se pide confirmación para aplicar cambios.


// AUTENTICACIÓN:
// Cada proveedor utiliza un método diferente.
// Consultar documentación

// 2.1 RECURSOS
// RED
resource "oci_core_vcn" "example_vcn" {
  compartment_id = var.tenancy_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "example-vcn"
}

resource "oci_core_subnet" "example_subnet" {
  compartment_id      = var.tenancy_ocid
  vcn_id              = oci_core_vcn.example_vcn.id
  cidr_block          = "10.0.0.0/24"
  display_name        = "example-subnet"
  availability_domain = "V1"
}

resource "oci_core_internet_gateway" "example_ig" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.example_vcn.id
  display_name   = "example-ig"
}

// INSTANCIA
resource "oci_core_instance" "example" {
  availability_domain = "V1"
  compartment_id      = var.tenancy_ocid
  shape               = "VM.Standard.E2.1.Micro"
  display_name        = "test-instance"

  create_vnic_details {
    subnet_id = "ocid1.subnet.oc1..xxxx"
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    image_id    = "ocid1.image.oc1..xxxx"
  }
}
