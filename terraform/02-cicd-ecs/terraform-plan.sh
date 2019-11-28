#!/bin/bash
registry_url="803808824931.dkr.ecr.us-east-1.amazonaws.com"
app_backend="simple-testing-capabilities:latest"
app_port_backend="50504"
app_frontend="simple-testing-capabilities-spa:latest"
app_port_frontend="3000"
terraform init -backend-config="profile=godel" 
terraform plan --var "app_image_backend=$registry_url/$app_backend" --var "app_port_backend=$app_port_backend" --var "app_image_frontend=$registry_url/$app_frontend" --var "app_port_frontend=$app_port_frontend"