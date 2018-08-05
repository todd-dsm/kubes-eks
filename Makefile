#!/usr/bin/env make
# vim: tabstop=8 noexpandtab

tf-init:
	terraform init -get=true

plan: tf-init
	terraform plan \
		-out=/tmp/kubes-eks.plan 

apply: tf-init 
	terraform apply --auto-approve -no-color \
		-input=false "/tmp/kubes-eks.plan" 2>&1 | tee /tmp/kubes-eks.out
	# Get kubeconfig 
	terraform output kubeconfig > secrets/auth/eks-staging-config
	# Join the workers to the masters
	terraform output config_map_aws_auth > addons/auth/config-map-aws-auth.yaml
	kubectl apply -f addons/auth/config-map-aws-auth.yaml
	cp terraform.tfstate* /tmp/kubes-eks/

clean: ## Destroy existing kubernetes resources, current build, and all generated files
	terraform destroy --force -auto-approve
	rm -f secrets/auth/eks-staging-config
	#aws s3 rm s3://ptest.vault/secrets --recursive
	#rm -rf $(ASSET_DIR)
	#rm -rf ./secrets/*
	#rm -rf .terraform
	#rm *tfstate*

