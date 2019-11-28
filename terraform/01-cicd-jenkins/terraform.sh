#!/bin/bash
echo "[i] Init for ........."
terraform init -backend-config="profile=godel"
terraform destroy -auto-approve -target null_resource.configure
echo "[i] Planning for ........."
terraform plan
echo "[i] Applying for ........."
terraform apply --auto-approve 
