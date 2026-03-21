# 🚀 Toggle Feature Platform - Complete Documentation

> Uma plataforma de **feature flags** serverless com **Infrastructure as Code**, **DevSecOps**, **GitOps** e **ArgoCD**.

![Architecture](https://img.shields.io/badge/Status-Fully%20Operational-brightgreen)
![AWS](https://img.shields.io/badge/AWS-EKS%2C%20RDS%2C%20Redis%2C%20SQS-orange)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28-blue)
![Terraform](https://img.shields.io/badge/IaC-Terraform-purple)
![GitOps](https://img.shields.io/badge/GitOps-ArgoCD-red)

---

## 📑 Documentação Completa

### 1. **[📐 Arquitetura (`ARCHITECTURE.md`)](ARCHITECTURE.md)**
Visão completa da arquitetura, fluxos de dados, comunicação entre serviços e design de segurança.

- Diagrama da plataforma completa
- Pipeline CI/CD/DevSecOps end-to-end
- Detalhes de cada microserviço
- Data flows
- GitOps workflow
- Padrões de comunicação
- Escalabilidade e disaster recovery

### 2. **[🏗️ Infrastructure as Code (`TERRAFORM.md`)](TERRAFORM.md)**
Guia completo sobre provisionar toda infraestrutura AWS via Terraform.

- Estrutura modular de módulos
- Descrição de cada módulo (VPC, EKS, RDS, etc)
- Como usar Terraform (init, plan, apply)
- Outputs importantes
- Security best practices
- Troubleshooting

### 3. **[📹 Guia de Demonstração (`DEMO_GUIDE.md`)](DEMO_GUIDE.md)**
Roteiro completo para fazer uma demonstração de 20 minutos.

- Cronograma por estágio
- Estágio 1: IaC com Terraform (4 min)
- Estágio 2: Pipeline DevSecOps com FALHA (4 min)
- Estágio 3: Correção e SUCCESS (4 min)
- Estágio 4: GitOps + ArgoCD (4 min)
- Dicas de apresentação
- Checklist de preparação

### 4. **[🔧 GitHub Actions Workflows](##-workflows)**
Referência dos workflows CI/CD/DevSecOps

---

## 🎯 Como Usar Esta Documentação

### 👨‍💻 Para Desenvolvedores
1. Leia [ARCHITECTURE.md](ARCHITECTURE.md) para entender o design
2. Consulte [Microserviços](#-microserviços) para seu serviço específico
3. Leia README.md de cada serviço em `Microservices/<service>/`

### 🏗️ Para DevOps/SRE
1. Leia [TERRAFORM.md](TERRAFORM.md) para provisionar infraestrutura
2. Entenda o [Terraform/modules/](Terraform/modules/) estrutura
3. Monitore com [Kubernetes](#-kubernetes)

### 🎤 Para Apresentações
1. Use [DEMO_GUIDE.md](DEMO_GUIDE.md) para demonstração
2. Siga o cronograma passo a passo
3. Use o checklist de preparação

### 🔒 Para Segurança
1. Revise [Security Layers](ARCHITECTURE.md#-security-layers)
2. Entenda [DevSecOps Pipeline](#-devsecops-pipeline)
3. Consulte [Secret Management](#-secret-management)

---

## 🌟 Features

### ✅ Infrastructure as Code
- [x] Terraform com módulos reutilizáveis
- [x] VPC, EKS, RDS (3 instâncias), Redis, SQS, DynamoDB
- [x] Remote state em S3 com versionamento
- [x] Auto-scaling e high availability

### ✅ DevSecOps Pipeline
- [x] Secret scanning (GitGuardian)
- [x] SAST scanning (Bandit, gosec)
- [x] Dependency checking (Safety)
- [x] Container scanning (Trivy)
- [x] SBOM generation (Syft)
- [x] Automated remediation

### ✅ GitOps
- [x] ArgoCD para reconciliação automática
- [x] Git como fonte de verdade
- [x] Image tag auto-update
- [x] Pull-based deployment

### ✅ Kubernetes
- [x] 5 microserviços deployados
- [x] Multi-namespace isolation
- [x] Service discovery
- [x] Load balancing
- [x] Health checks
- [x] Auto-scaling

---

## 📁 Estrutura do Repositório

```
toggle-feature-terraform/
├── Terraform/                    # Infrastructure as Code
│   ├── live/                    # Configurações por ambiente
│   │   ├── global/              # Shared config
│   │   ├── analytics/
│   │   ├── auth/
│   │   ├── evaluation/
│   │   ├── flag/
│   │   └── targeting/
│   └── modules/                 # Módulos reutilizáveis
│       ├── vpc/
│       ├── eks/
│       ├── rds/
│       ├── dynamodb/
│       ├── sqs/
│       ├── redis/
│       ├── ecr/
│       └── k8s_deploy/
│
├── Microservices/               # Source code dos serviços
│   ├── analytics-service/       # Python - Eventos
│   ├── auth-service/            # Go - Autenticação
│   ├── evaluation-service/      # Go - Avaliação
│   ├── flag-service/            # Python - Flags
│   ├── targeting-service/       # Python - Segmentação
│   └── docker-compose.yml       # Local development
│
├── Kubernetes/                  # Kubernetes manifests (mirror)
│   ├── analytics-service/
│   ├── auth-service/
│   ├── evaluation-service/
│   ├── flag-service/
│   └── targeting-service/
│
├── GitOps/                      # ArgoCD source (Git source of truth)
│   ├── analytics-service/
│   ├── auth-service/
│   ├── evaluation-service/
│   ├── flag-service/
│   ├── targeting-service/
│   └── argocd/
│
├── .github/
│   └── workflows/
│       ├── microservices-ci-cd-devsecops.yml    # Main pipeline
│       └── [individual service workflows]
│
├── ARCHITECTURE.md              # 📐 Arquitetura completa
├── TERRAFORM.md                 # 🏗️ Guia de Terraform
├── DEMO_GUIDE.md               # 📹 Guia de demonstração
├── README.md                   # Este arquivo
└── terraform.tfstate           # State file (em produção)
```

---

## 🚀 Quick Start

### Pré-requisitos
```bash
# Tools necessárias
- AWS CLI (configurado com credenciais)
- Terraform >= 1.0
- kubectl >= 1.28
- Docker
- Git
```

### 1️⃣ Provisionar Infraestrutura
```bash
cd Terraform/live/global
terraform init
terraform plan -out=tfplan
terraform apply tfplan

# Salvar outputs
terraform output > /tmp/outputs.txt
```

### 2️⃣ Setup do kubeconfig
```bash
# Atualizar kubeconfig
aws eks update-kubeconfig --name toggle-feature-cluster

# Verificar acesso
kubectl cluster-info
kubectl get nodes
```

### 3️⃣ Deploy dos Microserviços (via ArgoCD)
```bash
# ArgoCD já sincroniza automaticamente
# Verificar status
kubectl get applications.argoproj.io -n argocd
kubectl get deploy -n analytics-service,auth-service,evaluation-service,flag-service,targeting-service
```

### 4️⃣ Acessar Serviços
```bash
# Port-forward para testes locais
kubectl port-forward -n flag-service svc/flag-service-service 5002:5002
kubectl port-forward -n auth-service svc/auth-service-service 5010:5010

# Testar
curl http://localhost:5002/health
curl http://localhost:5010/health
```

---

## 🏃 Microserviços

| Serviço | Linguagem | Porta | Função | Database |
|---------|-----------|-------|--------|----------|
| **analytics-service** | Python | 5001 | Eventos | DynamoDB |
| **auth-service** | Go | 5010 | Autenticação | RDS (auth-db) |
| **evaluation-service** | Go | 5004 | Avaliação | Redis |
| **flag-service** | Python | 5002 | Feature Flags | RDS (flag-db) |
| **targeting-service** | Python | 5003 | Segmentação | RDS (targeting-db) |

### Acessar README de Cada Serviço
```bash
cat Microservices/analytics-service/README.md
cat Microservices/auth-service/README.md
# ... etc
```

---

## 🔄 CI/CD Pipeline

### Fluxo Completo
```
Developer Code Push
    ↓
GitHub Actions triggers
    ├─ Detect changed services
    ├─ Security Scans
    │   ├─ GitGuardian (secrets)
    │   ├─ Bandit/gosec (SAST)
    │   ├─ Safety/go mod (dependencies)
    │   └─ Trivy (container)
    ├─ Build Docker image
    ├─ Generate SBOM
    └─ Push to ECR + Update GitOps
    ↓
GitOps push triggers
    ↓
ArgoCD detects
    ├─ Sync detected
    ├─ Manifest diff
    └─ Auto-apply (if enabled)
    ↓
Kubernetes reconciliation
    ├─ Pull new image
    ├─ Create pod
    ├─ Run health checks
    └─ Route traffic
    ↓
Stable running state
```

### Acessar Workflow Logs
```bash
# GitHub Actions
https://github.com/YOUR_REPO/actions

# ArgoCD UI
kubectl port-forward -n argocd svc/argocd-server 8080:443
# https://localhost:8080
```

---

## 🔐 DevSecOps Pipeline

### Ferramentas Implementadas

| Tool | Função | Estágio |
|------|--------|---------|
| **GitGuardian** | Secret detection | Pre-build |
| **Bandit** | Python SAST | Pre-build (Python) |
| **gosec** | Go SAST | Pre-build (Go) |
| **Safety** | Dependency check (Python) | Pre-build |
| **Trivy** | Container scanning | Post-build |
| **Syft** | SBOM generation | Post-build |

### Falha Pipeline
Pipeline falha (e NÃO faz push para ECR) se:
```
❌ Secrets detectadas no código
❌ Vulnerabilidades SAST críticas encontradas
❌ Dependências vulneráveis
❌ Imagem tem CVE CRITICAL/HIGH
```

---

## 📊 Kubernetes

### Status Atual
```bash
# Ver deployments
kubectl get deploy -A

# Ver pods
kubectl get pods -n analytics-service,auth-service,evaluation-service,flag-service,targeting-service

# Ver services
kubectl get svc -A

# Ver ingress
kubectl get ing -A
```

### Logs
```bash
# Ver logs de um serviço
kubectl logs -n analytics-service -f deployment/analytics-service-deployment

# Descrever recurso
kubectl describe pod -n analytics-service <pod-name>

# Debug
kubectl debug -n analytics-service <pod-name> -it --image=busybox
```

### Scale
```bash
# Escalar manualmente
kubectl scale deployment analytics-service-deployment -n analytics-service --replicas=3

# Ver HPA
kubectl get hpa -A
```

---

## 🔐 Secret Management

### Variáveis de Ambiente por Serviço

**analytics-service:**
```
AWS_REGION
AWS_SQS_URL
AWS_DYNAMODB_TABLE
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

**auth-service:**
```
DATABASE_URL (PostgreSQL)
MASTER_KEY
```

**flag-service:**
```
DATABASE_URL (PostgreSQL)
AUTH_SERVICE_URL
```

**targeting-service:**
```
DATABASE_URL (PostgreSQL)
AUTH_SERVICE_URL
```

**evaluation-service:**
```
REDIS_URL
AWS_SQS_URL
AWS_REGION
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

### Updates de Secrets
```bash
# Atualizar secret
kubectl create secret generic analytics-service-secret \
  --from-literal=AWS_REGION='us-east-1' \
  --from-literal=AWS_SQS_URL='https://sqs.us-east-1.amazonaws.com/xxx' \
  --dry-run=client -o yaml | kubectl apply -f -

# Reiniciar pods para aplicar
kubectl rollout restart deployment/analytics-service-deployment -n analytics-service
```

---

## 📈 Monitoring

### Métricas Disponíveis
```bash
# CPU/Memory
kubectl top nodes
kubectl top pods -A

# Pod status
kubectl get pods -A --watch

# Events
kubectl get events -A --sort-by='.lastTimestamp'
```

### Health Checks
```bash
# Verificar health de um serviço
kubectl exec -n analytics-service <pod> -- curl localhost:5001/health

# Verificar conectividade DB
kubectl exec -n auth-service <pod> -- psql -h <db-host> -U <user> -d <db> -c "\l"
```

---

## 🆘 Troubleshooting

### Pod em CrashLoopBackOff
```bash
# Ver logs
kubectl logs -n <namespace> <pod> --previous

# Descrição do pod
kubectl describe pod -n <namespace> <pod>

# Possíveis causas:
# - Missing environment variable
# - Database connection failed
# - Secret not found
# - Image pull error
```

### ArgoCD fora de Sync
```bash
# Ver status
kubectl get applications.argoproj.io -n argocd -o wide

# Forçar sync
kubectl patch application <app> -n argocd -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}' --type merge

# Ver recursos
kubectl describe application <app> -n argocd
```

### Timeout de Conexão DB
```bash
# Verificar security group
aws ec2 describe-security-groups --group-ids <sg-id>

# Verificar subnets
kubectl get pod -n auth-service -o wide

# Testar conectividade
kubectl exec -n auth-service <pod> -- nc -zv <db-host> 5432
```

---

## 📚 Recursos

### Documentação
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [ArgoCD Docs](https://argo-cd.readthedocs.io/)
- [AWS EKS Docs](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/)

### Artigos
- [12 Factor App](https://12factor.net/)
- [GitOps Principles](https://opengitops.dev/)
- [Cloud Native Security](https://www.cncf.io/blog/)

### Comunidades
- [CNCF Slack](https://cloud-native.slack.com/)
- [Kubernetes Community](https://kubernetes.io/community/)
- [ArgoCD Community](https://github.com/argoproj-labs)

---

## 🤝 Contribuindo

### Workflow de Desenvolvimento
1. Clone o repositório
2. Crie uma branch: `git checkout -b feature/sua-feature`
3. Faça mudanças
4. Commit: `git commit -m "feat: adicionar X"`
5. Push: `git push origin feature/sua-feature`
6. Crie um PR
7. Aguarde pipeline passar
8. Merge após aprovação

### Código Review
- Mínimo 1 aprovação
- Pipeline deve passar
- Tests devem passar
- Security checks devem passar

---

## 📞 Suporte

### Questões?
1. Consulte a documentação relevante acima
2. Procure em issues do GitHub
3. Crie uma nova issue com contexto

### Reportar Bug
Inclua:
- Descrição do problema
- Passos para reproduzir
- Versões (Terraform, Kubernetes, etc)
- Logs relevantes

---

## 📄 Licença

Proprietary - Toggle Feature Platform

---

## 🎉 Próximas Passos

- [ ] Ler [ARCHITECTURE.md](ARCHITECTURE.md) para entender design
- [ ] Ler [TERRAFORM.md](TERRAFORM.md) para provisionar
- [ ] Ler [DEMO_GUIDE.md](DEMO_GUIDE.md) para demonstração
- [ ] Fazer backup do terraform.tfstate
- [ ] Configurar alertas e monitoramento
- [ ] Documentar procedures de runbook

---

**Desenvolvido com ❤️ para Feature Flag Management**

`Last Updated: March 2026`
