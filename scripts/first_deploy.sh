cd ../infrastructure/environments/dev/vpc
terragrunt init
terragrunt apply -auto-approve
cd ../eks
terragrunt init
terragrunt apply -auto-approve
aws eks update-kubeconfig --name dev-eks --region us-east-1
cd ../argocd
terragrunt init
terragrunt apply -auto-approve
cd ../nginx-ingress
terragrunt init
terragrunt apply -auto-approve
cd ../external-secrets/helm
terragrunt init
terragrunt apply -auto-approve
cd ../manifests
terragrunt init
terragrunt apply -auto-approve
cd ../../applications/helm-dev-app
terragrunt init
terragrunt apply -auto-approve