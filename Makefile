.PHONY: init plan apply show destroy

init:
	command -v terraform >/dev/null 2>&1 || { echo "terraform is not in PATH.  Aborting." >&2; exit 1; }
	rm -rf .terraform/terraform.tfstate
	terraform init

plan:
	terraform plan -var-file=config/stage.tfvars

apply:
	terraform apply -var-file=config/stage.tfvars

show:
	terraform show -var-file=config/stage.tfvars

destroy:
	terraform destroy -var-file=config/stage.tfvars
