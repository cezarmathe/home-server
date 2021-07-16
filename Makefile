# Makefile

# this is used for the ci

# Set the shell to bash.
SHELL = /bin/bash

# Age identity.
AGE_IDENTITY ?= keys/$(shell whoami).key
AGE_IDENTITY_EXPANDED = -i $(AGE_IDENTITY)

# Age recipients.
AGE_RECIPIENTS ?= keys/*.key.pub
AGE_RECIPIENTS_EXPANDED = $(shell ./scripts/gen_recipients.sh $(AGE_RECIPIENTS))

# Age encrypt command.
AGE_ENCRYPT = age --armor $(AGE_RECIPIENTS_EXPANDED)

# Age decrypt command.
AGE_DECRYPT = age --decrypt $(AGE_IDENTITY_EXPANDED)

# Files that contain sensitive information and should be encrypted / decrypted
# on demand.
SECRETS ?= main_override.tf backend.tfvars env/v1.tfvars env/default.tfvars
SECRETS_ENCRYPT = $(shell for file in $(SECRETS); do printf "%s" "$${file}.age($${file}) "; done)
SECRETS_DECRYPT = $(shell for file in $(SECRETS); do printf "%s" "$${file}($${file}.age) "; done)

# Workspace.
WORKSPACE ?= v1

# Whether to auto-approve runs or not.
AUTO_APPROVE ?= 1
AUTO_APPROVE_EXPANDED = $(shell if [[ "$(AUTO_APPROVE)" != 0 ]]; then printf "%s" "--auto-approve "; fi)

# Encrypt all files by default.
all: encrypt

# Encrypt all files that need to be encrypted.
encrypt: $(SECRETS_ENCRYPT)

# Decrypt all encrypted files.
decrypt: $(SECRETS_DECRYPT)

$(SECRETS_ENCRYPT):
	$(AGE_ENCRYPT) -o $@ $%
.PHONY: $(SECRETS_ENCRYPT)

$(SECRETS_DECRYPT):
	$(AGE_DECRYPT) -o $@ $%
.PHONY: $(SECRETS_DECRYPT)

# Flag for enabling output to stdout.
STDOUT ?= 0
# Command for writing the output of terraform.
OUTPUT = tee \
	"$(shell date +%Y_%m_%d-%H_%M_%S ).log" \
	$(shell if [[ "$(STDOUT)" == "0" ]]; then printf "%s" ">/dev/null"; fi)

# Initialize terraform.
init:
	terraform init \
		-backend-config=backend.tfvars
.PHONY: init

# Create & update resources.
apply:
	terraform workspace select $(WORKSPACE)
	terraform apply \
		$(AUTO_APPROVE_EXPANDED) \
		-input=false \
        --var-file=env/$(WORKSPACE).tfvars \
		-no-color \
		| $(OUTPUT)
.PHONY: apply

destroy:
	terraform workspace select $(WORKSPACE)
	terraform apply \
		-destroy \
		$(AUTO_APPROVE_EXPANDED) \
		-input=false \
        --var-file=env/$(WORKSPACE).tfvars \
		-no-color \
		| $(OUTPUT)
.PHONY: destroy
