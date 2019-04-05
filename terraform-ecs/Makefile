ENVNAME = nonprod
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
		-var-file=./vars/$(ENVNAME).tfvars \
		./

apply: ## - Apply Changes
	@echo "[i] Applying for $(ENVNAME)"
	@terraform apply -backup=./terraform/ \
		./${TFPLANFILE}
	@rm -rf $(TFPLANFILE)

destroy: ## - Destroy everything in the TF environment
	@terraform destroy -var-file=vars/$(ENVNAME).tfvars \
		-backup=./ \
		-var project_id="$(ENVNAME)" \
		./

	@rm -rf $(TFPLANFILE)

