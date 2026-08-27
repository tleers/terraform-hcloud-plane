.DEFAULT_GOAL := help

TOFU := ./scripts/tofu.sh

.PHONY: help init fmt fmt-check validate test lint security docs plan apply destroy clean

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*## "; printf "Usage: make <target>\n\n"} /^[a-zA-Z_-]+:.*## / {printf "  %-14s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Initialize providers without contacting Hetzner
	tofu init

fmt: ## Format all OpenTofu files
	tofu fmt -recursive

fmt-check: ## Verify formatting without modifying files
	tofu fmt -recursive -check -diff

validate: ## Initialize without a backend and validate
	tofu init -backend=false
	tofu validate

test: ## Run native OpenTofu tests without creating infrastructure
	tofu test -var-file=tests/test.tfvars

lint: ## Run TFLint
	tflint --init
	tflint --recursive

security: ## Scan configuration with Trivy
	trivy config .

docs: ## Regenerate the module input/output reference
	terraform-docs markdown table --output-file docs/module-reference.md --output-mode inject .

plan: ## Create a saved plan
	$(TOFU) plan -out=plane.tfplan

apply: ## Apply the saved plan
	$(TOFU) apply plane.tfplan

destroy: ## Preview destruction; protection must be disabled separately
	$(TOFU) plan -destroy

clean: ## Remove only generated local initialization data
	@echo "Remove .terraform/ and saved plans manually after confirming the exact paths."
