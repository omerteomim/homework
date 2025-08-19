cd ../infrastructure/environments/dev/
terragrunt destroy all -auto-approve

cd ../prod
terragrunt destroy all -auto-approve


