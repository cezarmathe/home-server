# Makefile

# this is used for the ci

# Set the shell to bash.
SHELL = /bin/bash

# Age identity.
AGE_IDENTITY ?= ~/.age/key
AGE_IDENTITY_EXPANDED = -i $(AGE_IDENTITY)

# Age recipients.
AGE_RECIPIENTS ?=
AGE_RECIPIENTS_EXPANDED = $(shell for key in $(AGE_RECIPIENTS); do printf "%s" "-r $${key} "; done)

# Age encrypt command.
AGE_ENCRYPT = age --armor $(AGE_RECIPIENTS_EXPANDED)

# Age decrypt command.
AGE_DECRYPT = age --decrypt $(AGE_IDENTITY_EXPANDED)

# Initialize the workspace.
init:
	$(AGE_DECRYPT) -o backend.tfvars backend.tfvars.age
	terraform init -backend-config=backend.tfvars
.PHONY: init
