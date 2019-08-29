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
	@rm -rf .terraform terraform/01-cicd-jenkins/modules terraform/01-cicd-jenkins/terraform.plan terraform/01-cicd-jenkins/${TFPLANFILE} && echo -ne "Done\n"

plan00:
	@echo "[i] Initializing for $(ENVNAME)"
	@terraform init terraform/00-cicd-infra/
	@echo "[i] Planning for $(ENVNAME)"
	@terraform plan --var-file=terraform/00-cicd-infra/vars/$(ENVNAME).tfvars terraform/00-cicd-infra/

apply00: ## - Apply Changes
	@echo "[i] Applying for $(ENVNAME)"
	@terraform apply --auto-approve --var-file=terraform/00-cicd-infra/vars/$(ENVNAME).tfvars terraform/00-cicd-infra/
	@rm -rf terraform/00-cicd-infra/$(TFPLANFILE)

plan01: ## - Plan
	@echo "[i] Initializing for $(ENVNAME)"
	@terraform init terraform/01-cicd-jenkins/
	@echo "[i] Planning for $(ENVNAME)"
	@terraform plan --var-file=terraform/01-cicd-jenkins/vars/$(ENVNAME).tfvars terraform/01-cicd-jenkins/
		
apply01: ## - Apply Changes
	@echo "[i] Applying for $(ENVNAME)"
	@terraform apply --auto-approve --var-file=terraform/01-cicd-jenkins/vars/$(ENVNAME).tfvars terraform/01-cicd-jenkins/
	@rm -rf terraform/01-cicd-jenkins/$(TFPLANFILE)

destroy01: ## - Destroy everything in the TF environment
	@terraform destroy -var-file=terraform/01-cicd-jenkins/vars/$(ENVNAME).tfvars \
		-backup=./terraform/01-cicd-jenkins/ \
		-var project_id="$(ENVNAME)" \
		terraform/01-cicd-jenkins/

	@rm -rf terraform/01-cicd-jenkins/$(TFPLANFILE)

