#!/bin/bash
registry_url="803808824931.dkr.ecr.us-east-1.amazonaws.com"
app_backend="simple-testing-capabilities:latest"
app_port_backend="50504"
app_frontend="simple-testing-capabilities-spa:latest"
app_port_frontend="3000"
app_db="redis:latest"
app_port_db="6379"

terraform init -reconfigure
terraform plan --var-file=vars/nonprod.tfvars --var "app_image_backend=$registry_url/$app_backend" --var "app_port_backend=$app_port_backend" --var "app_image_frontend=$registry_url/$app_frontend" --var "app_port_frontend=$app_port_frontend" --var "app_image_db=$app_db" --var "app_port_db=$app_port_db"

terraform apply --var-file=vars/nonprod.tfvars --var "app_image_backend=$registry_url/$app_backend" --var "app_port_backend=$app_port_backend" --var "app_image_frontend=$registry_url/$app_frontend" --var "app_port_frontend=$app_port_frontend" --var "app_image_db=$app_db" --var "app_port_db=$app_port_db"