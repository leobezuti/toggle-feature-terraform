# 🏗️ Infrastructure as Code - Terraform

## 📋 Visão Geral

Esta documentação descreve como toda a infraestrutura do Toggle Feature é gerenciada via **Terraform** de forma modular e reutilizável.

---

## 📁 Estrutura de Diretórios

```
Terraform/
├── live/                          # Configurações por ambiente
│   ├── global/                   # Config compartilhada
│   │   ├── backend.tf           # S3 remote state
│   │   ├── provider.tf          # AWS provider
│   │   ├── main.tf              # Modelos
│   │   ├── variables.tf         # Variáveis de entrada
│   │   ├── outputs.tf           # Outputs
│   │   └── terraform.tfvars     # Valores das variáveis
│   ├── analytics/               # Recursos específicos Analytics
│   ├── auth/                    # Recursos específicos Auth
│   ├── evaluation/              # Recursos específicos Evaluation
│   ├── flag/                    # Recursos específicos Flag
│   └── targeting/               # Recursos específicos Targeting
└── modules/                       # Módulos reutilizáveis
    ├── vpc/                     # Virtual Private Cloud
    ├── eks/                     # Elastic Kubernetes Service
    ├── rds/                     # Relational Database Service
    ├── dynamodb/                # DynamoDB tables
    ├── sqs/                     # Simple Queue Service
    ├── redis/                   # ElastiCache Redis
    ├── ecr/                     # Elastic Container Registry
    └── k8s_deploy/              # Kubernetes deployments

```

---

## 🔧 Módulos Disponíveis

### 1. VPC Module (`modules/vpc/`)

**Objetivo:** Criar a rede privada na AWS com subnets públicas e privadas.

**Recursos Criados:**
- VPC principal
- Subnets públicas (para load balancer)
- Subnets privadas (para aplicações)
- Internet Gateway
- NAT Gateway
- Route Tables

**Variáveis Principais:**
```hcl
vpc_name      = "toggle-feature-vpc"
vpc_cidr      = "10.0.0.0/16"
public_subnets = {
  "public-1a" = { cidr_block = "10.0.1.0/24", az = "us-east-1a" }
  "public-1b" = { cidr_block = "10.0.2.0/24", az = "us-east-1b" }
}
private_subnets = {
  "private-1a" = { cidr_block = "10.0.10.0/24", az = "us-east-1a" }
  "private-1b" = { cidr_block = "10.0.11.0/24", az = "us-east-1b" }
}
```

**Outputs:**
- `vpc_id` - ID da VPC
- `public_subnet_ids` - IDs das subnets públicas
- `private_subnet_ids` - IDs das subnets privadas

---

### 2. EKS Module (`modules/eks/`)

**Objetivo:** Criar o cluster Kubernetes gerenciado na AWS.

**Recursos Criados:**
- Cluster EKS
- Node group com Auto Scaling
- IAM roles e políticas
- Security groups
- OIDC provider para IRSA

**Variáveis Principais:**
```hcl
cluster_name       = "toggle-feature-cluster"
cluster_version    = "1.28"
desired_size       = 2
min_size           = 1
max_size           = 4
instance_types     = ["t3.medium"]
```

**Outputs:**
- `cluster_id` - ID do cluster
- `cluster_endpoint` - URL do API server
- `cluster_arn` - ARN do cluster

---

### 3. RDS Module (`modules/rds/`)

**Objetivo:** Provisionar 3 instâncias PostgreSQL para cada microsserviço.

**Recursos Criados por Serviço:**
- RDS PostgreSQL instance
- Security group
- DB subnet group
- Parameter group
- Automated backup
- Secrets Manager para senha

**Instâncias Criadas:**
1. **auth-db** - Autenticação (Auth Service)
2. **flag-db** - Feature Flags (Flag Service)
3. **targeting-db** - Segmentação (Targeting Service)

**Variáveis Principais:**
```hcl
db_instances = {
  "auth-db" = {
    engine_version = "15.3"
    allocated_storage = 100
    instance_class = "db.t3.medium"
  }
  "flag-db" = { ... }
  "targeting-db" = { ... }
}
```

**Outputs:**
- `db_endpoint` - Endereço do banco
- `db_username` - Usuário master
- `db_password` (via Secrets Manager)

---

### 4. DynamoDB Module (`modules/dynamodb/`)

**Objetivo:** Criar tabelas DynamoDB para armazenamento de eventos.

**Tabelas Criadas:**
- `ToggleMasterAnalytics` - Eventos de análise
- Índices GSI para queries eficientes

**Configuração:**
```hcl
tables = {
  "ToggleMasterAnalytics" = {
    partition_key = "event_id"
    sort_key = "timestamp"
    billing_mode = "PAY_PER_REQUEST"
  }
}
```

**TTL:** Registros antigos deletados automaticamente

---

### 5. SQS Module (`modules/sqs/`)

**Objetivo:** Criar filas de mensagens para processamento assíncrono.

**Filas Criadas:**
- `evaluation-queue` - Processamento de avaliações de flags

**Configuração:**
```hcl
queues = {
  "evaluation-queue" = {
    message_retention_seconds = 345600  # 4 dias
    visibility_timeout_seconds = 300
  }
}
```

---

### 6. Redis Module (`modules/redis/`)

**Objetivo:** Cache em memória para performance.

**Recursos Criados:**
- ElastiCache Redis cluster
- Security group
- Parameter group

**Configuração:**
```hcl
engine_version = "7.0"
node_type = "cache.t3.micro"
num_cache_nodes = 1
automatic_failover_enabled = false
```

---

### 7. ECR Module (`modules/ecr/`)

**Objetivo:** Container registry para imagens Docker.

**Repositórios Criados:**
- `analytics-service`
- `auth-service`
- `evaluation-service`
- `flag-service`
- `targeting-service`

**Configuração:**
```hcl
image_tag_mutability = "IMMUTABLE"
image_scan_on_push = true
lifecycle_policy = "keep_last_30_images"
```

---

### 8. K8S Deploy Module (`modules/k8s_deploy/`)

**Objetivo:** Deployments Kubernetes para os microsserviços.

**Recursos Criados:**
- Deployments
- Services
- Ingress
- Namespaces
- RBAC

---

## 🚀 Como Usar o Terraform

### 1️⃣ Inicialização

```bash
cd Terraform/live/global

# Inicializar backend (S3 remote state)
terraform init

# Validar sintaxe
terraform validate
```

### 2️⃣ Planejamento

```bash
# Ver mudanças que serão aplicadas
terraform plan -out=tfplan

# Salvar plano
terraform show tfplan
```

### 3️⃣ Aplicação

```bash
# Aplicar infraestrutura
terraform apply tfplan

# Ou diretamente
terraform apply -auto-approve

# ⏱️ Tempo esperado: 15-20 minutos
```

### 4️⃣ Destruição (Cuidado!)

```bash
# Destroir toda infraestrutura
terraform destroy -auto-approve

# Apenas um recurso
terraform destroy -target='aws_instance.example'
```

---

## 📊 Outputs Importantes

Após `terraform apply`, você terá:

```bash
# Ver todos os outputs
terraform output

# Outputs principais:
cluster_endpoint        = "https://xxx.eks.amazonaws.com"
rds_auth_address        = "auth-db.xxx.rds.amazonaws.com"
rds_flag_address        = "flag-db.xxx.rds.amazonaws.com"
rds_targeting_address   = "targeting-db.xxx.rds.amazonaws.com"
redis_endpoint          = "toggle-feature-redis.xxx.cache.amazonaws.com:6379"
ecr_registry            = "123456789.dkr.ecr.us-east-1.amazonaws.com"
```

---

## 🔐 Segurança

### ✅ Best Practices Implementadas

1. **Remote State Backend**
   - Estado armazenado em S3 com versionamento
   - Criptografia KMS
   - DynamoDB lock para evitar conflitos

2. **Networking**
   - RDS em subnets privadas (sem acesso público)
   - Security groups restritivos
   - VPC endpoints para serviços AWS

3. **IAM**
   - Roles específicas por serviço
   - Princípio do menor privilégio
   - IRSA para pods do EKS

4. **Secrets**
   - Senhas em AWS Secrets Manager
   - Rotação automática
   - Não versionadas no Git

5. **Backup**
   - RDS backup automatizado
   - DynamoDB point-in-time recovery
   - Retenção de 30 dias

---

## 🔍 Validação de Código

```bash
# Validar sintaxe
terraform validate

# Formatar código
terraform fmt -recursive

# Verificar segurança (Checkov)
pip install checkov
checkov -d Terraform/

# Custo estimado (Infracost)
infracost breakdown --path Terraform/
```

---

## 🔄 Versionamento do Estado

```bash
# Terraform state é armazenado em S3
aws s3 ls s3://toggle-feature-tfstate/

# Listar versões do state
aws s3api list-object-versions --bucket toggle-feature-tfstate

# Restaurar versão anterior (cuidado!)
terraform init -reconfigure
```

---

## 📝 Variáveis e Customização

### `terraform.tfvars`
```hcl
# Ambiente
aws_region = "us-east-1"
environment = "production"

# EKS
cluster_version = "1.28"
desired_node_count = 2
instance_type = "t3.medium"

# RDS
db_allocated_storage = 100
db_instance_class = "db.t3.medium"
backup_retention_days = 30

# Tags
common_tags = {
  Project = "Toggle Feature"
  Environment = "Production"
  ManagedBy = "Terraform"
  CostCenter = "Engineering"
}
```

---

## ⚠️ Troubleshooting

### Erro: "Access Denied"
```bash
# Pode ser credenciais AWS expired
aws sts get-caller-identity

# Refreshar credenciais
aws configure
```

### Erro: "Resource already exists"
```bash
# Importar recurso existente
terraform import <resource_type>.<name> <id>

# Exemplo:
terraform import aws_eks_cluster.main toggle-feature-cluster
```

### State Corrompido
```bash
# Fazer backup
aws s3 cp s3://toggle-feature-tfstate/terraform.tfstate ./backup.tfstate

# Recriar
rm terraform.tfstate*
terraform init -upgrade
```

---

## 📚 Recursos

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/)
- [Terraform Modules](https://registry.terraform.io/namespaces/terraform-aws-modules)
- [AWS Best Practices](https://docs.aws.amazon.com/wellarchitected)

---

## 📞 Suporte

Para questões sobre Terraform:
1. Verificar logs: `terraform refresh -v`
2. Comentar em PRs sobre mudanças de infraestrutura
3. Usar `terraform plan` antes de aplicar em produção
