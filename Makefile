ENVNAME = jenkins-ci-cd

.PHONY: help clean init plan apply destroy

SHELL = /bin/bash

TFBUCKETNAME = $(ENVNAME)-tfstate
TFPLANFILE = ${ENVNAME}-tf.plan


help:
	@echo -e "\nProject defaults:\n Environment: $(ENVNAME)"
	@echo -e "\n[!] You'll need to specify an action: \n"
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

clean: ## - Clean terraform state
	@echo -ne "[i] Cleaning Terraform: "
	@rm -rf .terraform terraform/01-terraform-jenkins/modules terraform/01-terraform-jenkins/terraform.plan terraform/01-terraform-jenkins/${TFPLANFILE} && echo -ne "Done\n"

init: ## - Initialize terraform
	@echo "[i] Initializing for $(ENVNAME)"
	@terraform init terraform/01-terraform-jenkins/

plan: ## - Plan
	@echo "[i] Planning for $(ENVNAME)"
	@terraform plan --var-file=terraform/01-terraform-jenkins/vars/$(ENVNAME).tfvars terraform/01-terraform-jenkins/
		
apply: ## - Apply Changes
	@echo "[i] Applying for $(ENVNAME)"
	@terraform apply --auto-approve --var-file=terraform/01-terraform-jenkins/vars/$(ENVNAME).tfvars terraform/01-terraform-jenkins/
	@rm -rf terraform/01-terraform-jenkins/$(TFPLANFILE)

destroy: ## - Destroy everything in the TF environment
	@terraform destroy -var-file=terraform/01-terraform-jenkins/vars/$(ENVNAME).tfvars \
		-backup=./terraform/01-terraform-jenkins/ \
		-var project_id="$(ENVNAME)" \
		terraform/01-terraform-jenkins/

	@rm -rf terraform/01-terraform-jenkins/$(TFPLANFILE)

