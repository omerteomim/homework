cd ../infrastructure/environments/dev/applications/helm-dev-app
terragrunt destroy -auto-approve
cd ../../nginx-ingress
terragrunt destroy -auto-approve
cd ../argocd
terragrunt destroy -auto-approve
cd ../eks
terragrunt destroy -auto-approve
cd ../vpc
terragrunt destroy -auto-approve

