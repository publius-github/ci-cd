ENVNAME = jenkins-ci-cd
PROFILE = godel
S3_BUCKET = cicd



.PHONY: help clean prepare plan apply destroy

SHELL = /bin/bash

TFBUCKETNAME = $(ENVNAME)-tfstate
TFPLANFILE = ${ENVNAME}-tf.plan

help:
	@echo -e "\nProject defaults:\n Environment: $(ENVNAME)"
	@echo -e "\n[!] You'll need to specify an action: \n"
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

## create s3 bucket for terraform states
# prepare:
# 	@echo "[i] Creating S3 for terraform state"
# 	@aws s3 mb s3://$(S3_BUCKET)
# 	@aws s3api put-object --bucket $(S3_BUCKET) --key terraform-state/  
# 	@echo "tfstate_bucket = "$(S3_BUCKET)"" >> terraform/00-cicd-jenkins/vars/$(ENVNAME).tfvars
# 	@echo "[i] Creating ECR docker image"


clean: ## - Clean terraform state
	@echo -ne "[i] Cleaning Terraform: "
	@rm -rf .terraform terraform/00-init/.terraform terraform/00-init/modules terraform/00-init/terraform.plan terraform/00-init/${TFPLANFILE} \
	terraform/01-cicd-jenkins/.terraform terraform/01-cicd-jenkins/modules terraform/01-cicd-jenkins/terraform.plan terraform/01-cicd-jenkins/${TFPLANFILE} \
	terraform/02-cicd-ecs/.terraform terraform/02-cicd-ecs/modules terraform/02-cicd-ecs/terraform.plan terraform/02-cicd-ecs/${TFPLANFILE} && echo -ne "Done\n"

00-init: ##
	@echo "[i] Initializing for $(ENVNAME)"
	@terraform init terraform/00-init/
	@echo "[i] Planning for $(ENVNAME)"
	@terraform plan terraform/00-init/
	@terraform apply --auto-approve terraform/00-init/
	@rm -rf terraform/00-init/$(TFPLANFILE)

01-plan: ##
	@echo "[i] Initializing for $(ENVNAME)"
	@terraform init terraform/01-cicd-jenkins/
	@echo "[i] Planning for $(ENVNAME)"
	@terraform plan terraform/01-cicd-jenkins/

01-apply: ##
	@cd terraform/01-cicd-jenkins/ && echo "[i] Initializing for $(ENVNAME)"
	@terraform init -backend-config="profile=godel" 
	@terraform destroy -auto-approve -target null_resource.configure
	@echo "[i] Planning for $(ENVNAME)"
	@terraform plan
	@echo "[i] Applying for $(ENVNAME)"
	@terraform apply --auto-approve 
	@cd ../..
	@rm -rf terraform/01-cicd-jenkins/$(TFPLANFILE)

01-cicd-jenkins-destroy: ##
	@echo "[i] Initializing for $(ENVNAME)"
	@terraform init terraform/01-cicd-jenkins/
	@echo "[i] Destroying for $(ENVNAME)"
	@terraform destroy --auto-approve terraform/01-cicd-jenkins/
	@rm -rf terraform/01-cicd-jenkins/$(TFPLANFILE)

# plan-ecs: ## - Plan
# 	@echo "[i] Initializing for $(ENVNAME)"
# 	@terraform init terraform/01-cicd-ecs/
# 	@echo "[i] Planning for $(ENVNAME)"
# 	@terraform plan --var-file=terraform/01-cicd-ecs/vars/$(ENVNAME).tfvars terraform/01-cicd-ecs/
