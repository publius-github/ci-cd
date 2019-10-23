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

prepare:
	@echo "[i] Creating S3 for terraform state"
	@aws s3 mb s3://$(S3_BUCKET)
	@aws s3api put-object --bucket $(S3_BUCKET) --key terraform-state/  
	@echo "tfstate_bucket = "$(S3_BUCKET)"" >> terraform/00-cicd-jenkins/vars/$(ENVNAME).tfvars
	@echo "[i] Creating ECR docker image"

clean: ## - Clean terraform state
	@echo -ne "[i] Cleaning Terraform: "
	@rm -rf .terraform terraform/00-cicd-jenkins/.terraform terraform/00-cicd-jenkins/modules terraform/00-cicd-jenkins/terraform.plan terraform/00-cicd-jenkins/${TFPLANFILE} && echo -ne "Done\n"

plan: ## - Plan
	@echo "[i] Initializing for $(ENVNAME)"
	@terraform init terraform/00-cicd-jenkins/
	@terraform destroy -auto-approve -target null_resource.configure -var-file=terraform/00-cicd-jenkins/vars/$(ENVNAME).tfvars terraform/00-cicd-jenkins/
	@echo "[i] Planning for $(ENVNAME)"
	@terraform plan terraform/00-cicd-jenkins/

plan-ecs: ## - Plan
	@echo "[i] Initializing for $(ENVNAME)"
	@terraform init terraform/01-cicd-ecs/
	@echo "[i] Planning for $(ENVNAME)"
	@terraform plan --var-file=terraform/01-cicd-ecs/vars/$(ENVNAME).tfvars terraform/01-cicd-ecs/
			
apply: ## - Apply Changes
	@echo "[i] Applying for $(ENVNAME)"
#	@terraform destroy -auto-approve -target null_resource.configure -var-file=terraform/00-cicd-jenkins/vars/$(ENVNAME).tfvars terraform/00-cicd-jenkins/
	@terraform apply --auto-approve terraform/00-cicd-jenkins/
	@rm -rf terraform/00-cicd-jenkins/$(TFPLANFILE)

destroy: ## - Destroy everything in the TF environment
	@terraform destroy -var-file=terraform/00-cicd-jenkins/vars/$(ENVNAME).tfvars \
		-backup=./terraform/00-cicd-jenkins/ \
		terraform/00-cicd-jenkins/
	@rm -rf terraform/00-cicd-jenkins/$(TFPLANFILE)

jenkins: ## - Destroy everything in the TF environment
	@
		-backup=./terraform/00-cicd-jenkins/ \
		terraform/00-cicd-jenkins/
	@rm -rf terraform/00-cicd-jenkins/$(TFPLANFILE)