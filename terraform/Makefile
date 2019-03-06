

ENVNAME = jenkins-ci-cd


.PHONY: help clean init plan apply destroy

SHELL = /bin/bash

TFBUCKETNAME = $(BASE_GCP_PROJECT_ID)-$(ENVNAME)-tfstate
TFPLANFILE = ${ENVNAME}-tf.plan

export TF_IN_AUTOMATION = 1

help:
	@echo -e "\nProject defaults:\n ProjectID: $(GCP_PROJECT_ID)\n Environment: $(ENVNAME)"
	@echo -e "\n[!] You'll need to specify an action: \n"
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

clean: ## - Clean terraform state
	@echo -ne "[i] Cleaning Terraform: "
	@rm -rf .terraform modules terraform.plan ${TFPLANFILE} && echo -ne "Done\n"

init: ## - Initialize terraform
	@echo "[i] Initializing for $(ENVNAME)"
	@terraform init \
		-backend-config "bucket=$(TFBUCKETNAME)" \
		-backend-config "prefix=$(ENVNAME)" \
		-backend-config "credentials=${CREDSFILE}" \
		-get=true

plan: ## - Plan
	@echo "[i] Planning for $(ENVNAME)"
	@terraform plan -out=${TFPLANFILE} \
		-var-file=vars/$(ENVNAME).tfvars

apply: ## - Apply Changes
	@echo "[i] Applying for $(ENVNAME)"
	@terraform apply ${TFPLANFILE}
	@rm -rf $(TFPLANFILE)

destroy: ## - Destroy everything in the TF environment
	@terraform destroy -var-file=vars/$(ENVNAME).tfvars \
		-var project_id="$(BASE_GCP_PROJECT_ID)-$(ENVNAME)"

	@rm -rf $(TFPLANFILE)

