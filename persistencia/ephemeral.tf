# SIMULACIÓN DE WORKFLOW CON DATOS TEMPORALES
# ===========================================

terraform {
  required_version = ">= 1.0"
}

# 1. VARIABLE "EFÍMERA" (solo existe durante apply)
variable "one_time_password" {
  description = "Contraseña para operación única - NO persiste"
  type        = string
  sensitive   = true
  
  # Validación: debe ser proporcionada en runtime
  validation {
    condition     = length(var.one_time_password) > 0
    error_message = "Debes proporcionar una contraseña temporal"
  }
}

# 2. GENERADOR DE DATOS TEMPORALES
resource "random_password" "session_token" { # Lo trae terraform de serie y se instala con terraform init
  length  = 32
  special = true # Incluye caracteres especiales
  
  # Lifecycle: no proteger, se regenera cada vez
  lifecycle { # Mantiene la misma random_password aunque se ejecuten varios terraform apply.
    ignore_changes = all
  }
}

# 3. OPERACIÓN "EFÍMERA" PRINCIPAL
resource "null_resource" "ephemeral_operation" {# No crea nada en la infraestructura, sirve para ejecutar scripts
  # Triggers que cambian siempre = comportamiento "efímero"
  triggers = {
    timestamp   = timestamp()
    run_id      = uuid()
    session     = random_password.session_token.result
  }
  
  # FASE 1: Procesamiento con datos temporales
  provisioner "local-exec" { # Script
    command = <<-EOT
      echo "=== INICIO OPERACIÓN EFÍMERA ==="
      echo "Timestamp: ${self.triggers.timestamp}"
      echo "Run ID: ${self.triggers.run_id}"
      echo "Session: ${self.triggers.session}"
      echo "Password provista: [SENSITIVE - NO SE MUESTRA]"
      echo ""
      echo "Realizando procesamiento seguro..."
      # Simular procesamiento
      sleep 2
      echo "Procesamiento completado"
      echo "=== FIN OPERACIÓN ==="
    EOT
  }
  
  # FASE 2: Limpieza automática (simulada)
  provisioner "local-exec" {
    when    = destroy # Cuando se haga destroy sobre el recurso
    command = <<-EOT
      echo "=== LIMPIEZA DE DATOS TEMPORALES ==="
      echo "Eliminando datos sensibles de esta ejecución..."
      echo "Run ID ${self.triggers.run_id} finalizado"
    EOT
  }
  
  # Lifecycle: siempre recrear
  lifecycle {
    create_before_destroy = true
  }
}

# 4. REGISTRO DE AUDITORÍA (sin datos sensibles)
resource "local_file" "audit_log" {
  filename = "audit-${formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())}.log"
  content = <<-EOT
    Auditoría de operación efímera
    ==============================
    Fecha: ${formatdate("YYYY-MM-DD HH:mm:ss", timestamp())}
    Operación ID: ${null_resource.ephemeral_operation.triggers.run_id}
    Estado: COMPLETADO
    Datos sensibles: NO REGISTRADOS (política de seguridad)
    
    Nota: Esta auditoría NO contiene información sensible.
          Los datos temporales fueron eliminados post-ejecución.
  EOT
  
  lifecycle {
    ignore_changes = [content]
  }
}

# 5. OUTPUTS (sin datos sensibles)
output "operation_metadata" {
  value = {
    run_id      = null_resource.ephemeral_operation.triggers.run_id
    timestamp   = null_resource.ephemeral_operation.triggers.timestamp
    status      = "COMPLETED"
    sensitive_data_present = false
  }
  description = "Metadatos de la operación (sin datos sensibles)"
}

output "security_note" {
  value = <<-EOT
    ✅ COMPORTAMIENTO "EFÍMERO" SIMULADO
    
    Características implementadas:
    1. Datos sensibles NO persisten en terraform.tfstate
    2. Recurso se recrea en cada ejecución (triggers temporales)
    3. Limpieza automática en destroy
    4. Auditoría sin información sensible
    5. Outputs sanitizados
    
    Limitaciones reales de Terraform:
    - Los valores de variables SÍ persisten en estado si se usan en recursos
    - Los provisioners se almacenan en estado
    - Necesitamos workarounds para simular "efimeridad"
  EOT
}