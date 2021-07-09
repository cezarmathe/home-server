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
SECRETS ?= backend.tfvars env/v1.tfvars
SECRETS_ENCRYPT = $(shell for file in $(SECRETS); do printf "%s" "$${file}.age($${file}) "; done)
SECRETS_DECRYPT = $(shell for file in $(SECRETS); do printf "%s" "$${file}($${file}.age) "; done)

# Do nothing by default.
all:
	@true

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
