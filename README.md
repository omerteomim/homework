# Homework Project

## Project Structure

```
.
├── containers/
│   ├── dev-app/
│   ├── prod-app/
│   └── staging-app/
├── infrastructure/
│   ├── environments/
│   │   ├── dev/
│   │   └── prod/
│   └── modules/
│       ├── argocd/
│       ├── eks/
│       ├── external-secrets/
│       ├── helm-app/
│       ├── nginx-ingress/
│       └── vpc/
├── scripts/
├── values/
└── .github/
```

### Key Directories

- **containers/**: Application source code and Dockerfiles for each environment (`dev-app`, `staging-app`, `prod-app`).
- **infrastructure/**: Infrastructure as code using Terraform and Terragrunt.
  - **modules/**: Reusable Terraform modules (EKS, ArgoCD, Helm, etc).
  - **environments/**: Environment-specific Terragrunt configurations.
- **values/**: Helm values files for each environment.
- **scripts/**: Utility scripts for deployment and destruction.
- **.github/**: CI/CD workflows.

### Application Deployment

- Application containers are built from the `containers/` directory and deployed via ArgoCD using Helm charts.
- Helm values for each environment are in the [`values/`](values/) directory.

## 🔑 Useful Commands

Connect kubectl to your EKS cluster:
```
aws eks update-kubeconfig --name dev-eks --region us-east-1
```
Get ArgoCD UI external IP:
```
kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```
Get NGINX Ingress external IP:
```
kubectl get svc ingress-nginx-controller -n ingress-nginx-${environment} -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

## CI/CD

This repository uses a **GitHub Actions CI pipeline** to automate building, tagging, and publishing Docker images for different environments, and then syncing those updates with the GitOps repo.

### 🔄 When it runs
- Triggered on every **push to the `main` branch**.

### 🛠️ What it does
1. **Checkout Code**  
   Pulls the latest code from the repository.

2. **Login to DockerHub**  
   Authenticates with DockerHub using secrets (`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`).

3. **Generate Image Version**  
   Creates a timestamp-based version tag (`YYYYMMDDHHMMSS`).

4. **Build & Push Images**  
   Builds and pushes Docker images for **dev**, **staging**, and **prod** environments:  
   - `omerteomim/dev-app:latest` and `omerteomim/dev-app:<version>`  
   - `omerteomim/staging-app:latest` and `omerteomim/staging-app:<version>`  
   - `omerteomim/prod-app:latest` and `omerteomim/prod-app:<version>`

5. **Update Helm Values**  
   Updates the `values-dev.yaml`, `values-staging.yaml`, and `values-prod.yaml` files with the new image tag.

6. **Sync with GitOps Repository**  
   Commits the updated `values/` files to the external GitOps repo [`omerteomim/homework-gitops`](https://github.com/omerteomim/homework-gitops), ensuring that Kubernetes deployments use the latest images.

### ✅ Benefits
- Fully automated **CI/CD workflow** for all environments.  
- Guarantees every deployment uses **unique, versioned images**.  
- Keeps GitOps repo always in sync with the latest container builds.  

## Usage

- Access the deployed applications via the endpoints exposed by your Kubernetes cluster.
- Each environment (`dev`, `staging`, `prod`) has its own app and configuration.

## Scripts

- [`scripts/first_deploy.sh`](scripts/first_deploy.sh): Run initial deployment.
- [`scripts/destroy_infra.sh`](scripts/destroy_infra.sh): Destroy all infrastructure.
