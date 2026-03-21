# 📹 Guia de Demonstração - Toggle Feature Terraform (20 min)

## Visão Geral
Este guia descreve como fazer uma demonstração completa do pipeline DevSecOps, IaC, GitOps e ArgoCD.

---

## ⏱️ Cronograma da Demonstração (20 minutos)

| Tempo | Seção | Duração |
|-------|-------|---------|
| 0-2 min | Introdução e Arquitetura | 2 min |
| 2-6 min | **Estágio 1: IaC com Terraform** | 4 min |
| 6-10 min | **Estágio 2: Pipeline DevSecOps (FALHA)** | 4 min |
| 10-14 min | **Estágio 3: Correção e Pipeline Sucesso** | 4 min |
| 14-18 min | **Estágio 4: GitOps + ArgoCD** | 4 min |
| 18-20 min | Resumo e Conclusão | 2 min |

---

## 🏗️ Estágio 1: Infrastructure as Code (IaC) - 4 minutos

### Objetivo
Demonstrar como toda a infraestrutura (VPC, EKS, RDS, Redis, SQS, DynamoDB) é criada via código Terraform.

### Passo 1.1: Visualizar Estrutura Terraform
```bash
# Terminal 1: Mostrar estrutura modular
cd Terraform
tree -L 2 -I 'node_modules'

# Explicar:
# - modules/: VPC, EKS, RDS, ECR, SQS, DynamoDB, Redis
# - live/: Configurações por ambiente (global, analytics, auth, etc)
```

**O que Mostrar:** Organização limpa e modular

### Passo 1.2: Validar Terraform
```bash
# Terminal: Validar sintaxe
cd Terraform/live/global/infrastructure
terraform validate

# Explicar: Verifica se a sintaxe está correta
```

**O que Mostrar:** ✅ Success. Terraform configuration is valid.

### Passo 1.3: Terraform Plan (Opcional)
```bash
# Mostrar o que seria criado (SEM aplicar!)
terraform plan -out=tfplan

# Explicar:
# - Número de recursos a criar
# - Estrutura de rede
# - Banco de dados
# - Cluster Kubernetes
```

**O que Mostrar:**
- Plan: X to add, 0 to change, 0 to destroy
- Recursos principais listados

### Passo 1.4: Resultado Final na AWS (Recomendado)
```bash
# Mostrar recursos criados na AWS
kubectl cluster-info
kubectl get nodes
aws ec2 describe-vpcs --query 'Vpcs[].[VpcId,CidrBlock,Tags[?Key==`Name`].Value]'
aws rds describe-db-instances --query 'DBInstances[].[DBInstanceIdentifier,Endpoint.Address]'
```

**O que Mostrar:**
- EKS cluster rodando com 2 nodes
- VPC criada via código
- RDS PostgreSQL instances
- Redis cluster

---

## 🔒 Estágio 2: Pipeline DevSecOps com Falha - 4 minutos

### Objetivo
Simular um erro no código que cause falha na verificação de segurança.

### Passo 2.1: Criar Erro Intencional no Código
Faça um commit com uma dependência vulnerável:

```bash
cd Microservices/analytics-service
```

**Opção A: Adicionar dependência vulnerável**
```bash
# Editar requirements.txt e adicionar versão antiga com vulnerabilidade
echo "requests==2.6.0" >> requirements.txt  # Versão com vulnerabilidade conhecida

git add requirements.txt
git commit -m "⚠️ [TEST] Add outdated requests dependency - DEMO ONLY"
```

**Opção B: Adicionar credenciais no código (Secret Detection)**
```bash
# Editar analytics-service e adicionar API key falsa
echo "API_KEY = 'AKIAIOSFODNN7EXAMPLE'" >> app.py

git add app.py
git commit -m "⚠️ [TEST] Add AWS API key - DEMO ONLY"
```

### Passo 2.2: Push para Trigger Pipeline
```bash
git push origin main
```

**O que Observar:** GitHub Actions começa a rodar

### Passo 2.3: Acompanhar Pipeline no GitHub
```
https://github.com/YOUR_REPO/actions
```

**Esperado:**
1. ✅ Checkout
2. ✅ Detect changes
3. ✅ Build Docker image
4. ⚠️ **Security Scan (SNYK/Trivy) - FALHA**
5. ❌ Pipeline para antes de push para ECR

**O que Mostrar no Terminal:**
```
Step: Security Scan with Trivy
scanning image...
Found vulnerabilities:
  - requests:2.6.0 (HIGH: CVE-2015-1000)
  - Credentials detected in app.py

ERROR: Image failed security scan
```

---

## ✅ Estágio 3: Correção e Pipeline Sucesso - 4 minutos

### Objetivo
Corrigir o erro e mostrar o pipeline passando com sucesso.

### Passo 3.1: Corrigir o Código
```bash
cd Microservices/analytics-service

# Remover dependência vulnerável
git reset HEAD requirements.txt
# ou editar requirements.txt removendo a linha com vulnerabilidade
echo "requests==2.31.0" > requirements.txt  # Versão atualizada

# Remover credenciais do código
git reset HEAD app.py
# ou remover a linha com API key do app.py

git add requirements.txt app.py
git commit -m "🔧 FIX: Update requests to 2.31.0 and remove hardcoded credentials"
```

### Passo 3.2: Push Correção
```bash
git push origin main
```

**O que Observar:** Pipeline dispara novamente

### Passo 3.3: Acompanhar Pipeline Bem-sucedido
```
https://github.com/YOUR_REPO/actions
```

**Esperado:**
1. ✅ Checkout
2. ✅ Detect changes
3. ✅ Security Scan - **PASSOU**
4. ✅ Build Docker image
5. ✅ Push para ECR
6. ✅ **Update GitOps Manifest**

**O que Mostrar:**
```
Step: Security Scan with Trivy
scanning image...
✅ No vulnerabilities found

Step: Build & Push Image
Tag: analytics-service:sha-XXXXX
Pushed to ECR: account.dkr.ecr.us-east-1.amazonaws.com/analytics-service:sha-XXXXX

Step: Update GitOps Manifest
Updated GitOps/analytics-service/deployment.yml
Image tag updated to: sha-XXXXX
```

---

## 🚀 Estágio 4: GitOps + ArgoCD - 4 minutos

### Objetivo
Mostrar ArgoCD detectando a mudança e sincronizando automaticamente.

### Passo 4.1: Visualizar Mudança no GitOps
```bash
# Ver o commit que atualizou a imagem
git log --oneline -5 | head -n 2

# Ver o arquivo atualizado
git show HEAD:GitOps/analytics-service/deployment.yml | grep -A 2 "image:"
```

**O que Mostrar:**
```
+ image: account.dkr.ecr.us-east-1.amazonaws.com/analytics-service:sha-NEW
```

### Passo 4.2: Acompanhar ArgoCD
**Abrir terminal 2:**
```bash
# Watch em tempo real
watch -n 2 "kubectl get applications.argoproj.io -n argocd -o jsonpath='{range .items[*]}{.metadata.name}{\"  => sync=\"}{.status.sync.status}{\" health=\"}{.status.health.status}{\"\\n\"}{end}'"
```

**Esperado:**
```
analytics-service  => sync=OutOfSync health=Progressing
analytics-service  => sync=Syncing health=Progressing
analytics-service  => sync=Synced health=Healthy ✅
```

### Passo 4.3: Verificar Pod Atualizado
```bash
# Ver o novo pod rodando
kubectl get pods -n analytics-service -o wide

# Ver logs do novo pod
kubectl logs -n analytics-service -f deployment/analytics-service-deployment
```

**O que Mostrar:**
```
NAME                                              READY   STATUS    RESTARTS   AGE
analytics-service-deployment-NEWID-xxxxx          1/1     Running   0          12s

Logs showing successful startup
```

### Passo 4.4: Confirmar Sincronização
```bash
# ArgoCD status
kubectl get applications.argoproj.io -n argocd -o jsonpath='{range .items[*]}{.metadata.name}{": "}{.status.sync.status}{" - "}{.status.health.status}{"\n"}{end}'
```

**Esperado:**
```
analytics-service: Synced - Healthy
auth-service: Synced - Healthy
evaluation-service: Synced - Healthy
flag-service: Synced - Healthy
targeting-service: Synced - Healthy
```

---

## 📊 Estágio 5: Resumo Visual - 2 minutos

### Mostrar Diagrama da Pipeline
```bash
# Abrir arquivo ARCHITECTURE.md para mostrar fluxo
cat ARCHITECTURE.md
```

### Recap dos Pontos Demonstrados
1. ✅ **IaC**: Toda infraestrutura declarativa
2. ✅ **DevSecOps**: Pipeline com segurança obrigatória
3. ✅ **GitOps**: Mudanças no código refletem instantaneamente
4. ✅ **ArgoCD**: Sincronização automática

---

## 🎬 Preparação Antes da Demonstração

### Checklist de Setup

```bash
# 1. Limpar commits de demo do repositório (fazer ANTES de gravar)
cd /seu/repo
git log --oneline | head -5
# Se houver commits "TEST" ou "DEMO", fazer:
git reset --hard origin/main

# 2. Verificar que todos os serviços estão healthy
kubectl get applications.argoproj.io -n argocd
kubectl get deploy -n analytics-service,auth-service,evaluation-service,flag-service,targeting-service

# 3. Abrir 3 terminais:
# Terminal 1: GitOps (git/GitHub)
# Terminal 2: Kubernetes (watch de aplicações)
# Terminal 3: Logs

# 4. Ter estas URLs prontas no navegador:
# - GitHub Actions: https://github.com/YOUR_REPO/actions
# - ArgoCD UI: kubectl port-forward -n argocd svc/argocd-server 8080:443
```

### Dicas de Apresentação

✅ **Faça:**
- Pause entre cada estágio para explicar
- Use `watch` para mostrar mudanças em tempo real
- Tenha os URLs prontos em abas do navegador
- Explique o valor de cada estágio

❌ **Evite:**
- Correr rápido demais
- Muito scroll de código
- Jargão sem explicação
- Componentes muito grandes na tela

---

## 🔄 Tempo de Espera

| Ação | Tempo |
|------|-------|
| GitHub Actions rodar pipeline completo | ~3-5 min |
| ArgoCD detectar mudança | ~30 sec - 2 min |
| Pod atualizar e ficar Ready | ~1-2 min |

**Dica:** Se o tempo ficar curto, pré-gravar alguns estágios ou usar aceleração no vídeo.

---

## 📝 Notas para Roteiro

```
[0:00-2:00] INTRO
"Vamos demonstrar uma arquitetura moderna de cloud-native com:
- Infraestrutura como Código
- Pipeline de DevSecOps
- GitOps com ArgoCD"

[2:00-6:00] IaC TERRAFORM
"Toda a infraestrutura está definida em código. Vamos validar..."

[6:00-10:00] DEVSECOPS FAIL
"Vamos simular um erro comum - dependência vulnerável..."
"Pipeline detecta automaticamente!"

[10:00-14:00] DEVSECOPS SUCCESS
"Corrigimos o código e agora o pipeline passa..."

[14:00-18:00] GITOPS ARGOCD
"Quando o código é aprovado, ArgoCD sincroniza automaticamente..."

[18:00-20:00] WRAP UP
"Isso demonstra um workflow completo de CI/CD moderno!"
```

---

## 💾 Saída Esperada do Vídeo

Ao final, o vídeo deve mostrar:
1. ✅ Terraform validado e infraestrutura criada
2. ✅ Pipeline falhando por motivo de segurança
3. ✅ Código corrigido
4. ✅ Pipeline passando e imagem pushada para ECR
5. ✅ ArgoCD sincronizando automaticamente
6. ✅ Nova versão rodando no cluster

**Total de tempo:** 20 minutos ou menos
