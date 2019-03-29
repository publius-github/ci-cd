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
	@rm -rf .terraform terraform/modules terraform/terraform.plan terraform/${TFPLANFILE} && echo -ne "Done\n"

init: ## - Initialize terraform
	@echo "[i] Initializing for $(ENVNAME)"
	@terraform init \
		-backend-config "bucket=terraform/$(TFBUCKETNAME)" \
		-backend-config "prefix=terraform/$(ENVNAME)" \
		-backend-config "credentials=terraform/${CREDSFILE}" \
		-get=true \
		terraform

plan: ## - Plan
	@echo "[i] Planning for $(ENVNAME)"
	@terraform plan -out=terraform/${TFPLANFILE} \
		-var-file=./terraform/vars/$(ENVNAME).tfvars \
		terraform

apply: ## - Apply Changes
	@echo "[i] Applying for $(ENVNAME)"
	@terraform apply -backup=./terraform/ \
		./terraform/${TFPLANFILE}
	@rm -rf terraform/$(TFPLANFILE)

destroy: ## - Destroy everything in the TF environment
	@terraform destroy -var-file=terraform/vars/$(ENVNAME).tfvars \
		-backup=./terraform/ \
		-var project_id="$(ENVNAME)" \
		terraform

	@rm -rf terraform/$(TFPLANFILE)

