ENVNAME = jenkins-ci-cd
PROFILE = godel

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
	@rm -rf .terraform terraform/00-cicd-jenkins/.terraform terraform/00-cicd-jenkins/modules terraform/00-cicd-jenkins/terraform.plan terraform/00-cicd-jenkins/${TFPLANFILE} && echo -ne "Done\n"

plan: ## - Plan
	@echo "[i] Initializing for $(ENVNAME)"
	@terraform init terraform/00-cicd-jenkins/
	@terraform destroy -auto-approve -target null_resource.configure -var-file=terraform/00-cicd-jenkins/vars/$(ENVNAME).tfvars terraform/00-cicd-jenkins/
	@echo "[i] Planning for $(ENVNAME)"
	@terraform plan --var-file=terraform/00-cicd-jenkins/vars/$(ENVNAME).tfvars terraform/00-cicd-jenkins/
		
apply: ## - Apply Changes
	@echo "[i] Applying for $(ENVNAME)"
	@terraform apply --auto-approve --var-file=terraform/00-cicd-jenkins/vars/$(ENVNAME).tfvars terraform/00-cicd-jenkins/
	@rm -rf terraform/00-cicd-jenkins/$(TFPLANFILE)

destroy: ## - Destroy everything in the TF environment
	@terraform destroy -var-file=terraform/00-cicd-jenkins/vars/$(ENVNAME).tfvars \
		-backup=./terraform/00-cicd-jenkins/ \
		terraform/00-cicd-jenkins/
	@rm -rf terraform/00-cicd-jenkins/$(TFPLANFILE)
