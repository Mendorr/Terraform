# 1. Inicializar
terraform init

# 2. Ejecutar CON variable temporal (de línea de comandos)
terraform apply -var="one_time_password=TempPass123!" -auto-approve

# 3. Examinar el estado - ¿Qué persiste?
terraform show

# Buscar datos sensibles en el estado:
terraform show -json | jq '.values.root_module.resources[] | select(.type == "null_resource")'

# 4. Ejecutar de nuevo (con diferente password)
terraform apply -var="one_time_password=OtraPassword456!" -auto-approve

# 5. Comparar estados
terraform show -json | jq '.values.root_module.resources[0].values.triggers'

# 6. Destruir (ver limpieza)
terraform destroy -auto-approve

# 7. Verificar que NO queda rastro
ls -la *.tfstate*
cat terraform.tfstate | grep -i "password\|token\|secret"