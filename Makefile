# Makefile

# this is used for the ci

# Set the shell to bash.
SHELL = /bin/bash

# Age identity.
AGE_IDENTITY ?= ~/.age/key
AGE_IDENTITY_EXPANDED = $(shell printf "%s" "-i $(AGEAGE_IDENTITY) " )

# Age recipients.
AGE_RECIPIENTS ?=
AGE_RECIPIENTS_EXPANDED = $(shell for key in $(AGE_RECIPIENTS); do printf "%s" "-r ${key} ")

# Age encrypt command.
AGE_ENCRYPT = age --armor $(AGE_RECIPIENTS_EXPANDED)

# Age decrypt command.
AGE_DECRYPT = age --decrypt $(AGE_IDENTITY_EXPANDED)

# Initialize the workspace.
init:
    $(AGE_DECRYPT) -o backend.tfvars.age -i backend.tfvars
    terraform init
.PHONY: init
