# ✅ Demo Checklist - Toggle Feature Platform

Antes de fazer a demonstração, use este checklist para garantir que tudo está pronto.

## ⏰ Cronograma

- **Duração Total:** 20 minutos
- **Horário Recomendado:** Ter 5-10 minutos de folga antes
- **Ambiente:** Quiet space para possa ser ouvido

---

## 📋 Checklist de Preparação (T-30 min)

### ✅ Ambiente

- [ ] Terminal aberto em `/toggle-feature-terraform`
- [ ] AWS credentials configuradas: `aws sts get-caller-identity`
- [ ] kubectl acessível: `kubectl cluster-info`
- [ ] Docker rodando: `docker ps`
- [ ] Git configurado: `git config --list | grep user`

**Verificar com:**
```bash
# No repositório raiz
cd /seu/repo
aws sts get-caller-identity
kubectl cluster-info
git status
```

### ✅ Cluster Kubernetes

- [ ] Cluster está running
- [ ] Nodes estão Ready: `kubectl get nodes`
- [ ] ArgoCD está running: `kubectl get pods -n argocd | grep argocd-server`
- [ ] Todos os serviços estão Healthy: `kubectl get applications.argoproj.io -n argocd`

**Verificar com:**
```bash
kubectl get nodes
kubectl get applications.argoproj.io -n argocd
```

### ✅ Git e GitHub

- [ ] No branch correto: `git branch -v`
- [ ] Working directory limpo: `git status`
- [ ] Acesso ao repositório: `git remote -v`
- [ ] GitHub Actions disponível: Acessar Actions tab

**Verificar com:**
```bash
git status  # Deve estar clean
git branch
git remote -v
```

### ✅ Terraform

- [ ] Estado disponível: `terraform version`
- [ ] Remote state acessível (S3): `aws s3 ls | grep tfstate`
- [ ] Planejamento recente: `terraform show -json tfplan | head`

**Verificar com:**
```bash
cd Terraform/live/global
terraform version
terraform show
cd -
```

### ✅ Repositórios e Branches

- [ ] Repo estava em estado limpo (fazer backup git antes se necessário)
- [ ] Branch main está atualizado: `git pull origin main`
- [ ] Nenhum conflito: `git status`

**Verificar com:**
```bash
git log --oneline -5
git pull origin main
```

---

## 📊 Setup dos Terminais

### Terminal 1: Principal (Comandos CLI)
```bash
# Começar aqui
cd /caminho/para/toggle-feature-terraform
git status
```
**Usar para:** Comandos terraform, git, kubectl

### Terminal 2: Watch ArgoCD (Opcional)
```bash
watch -n 2 "kubectl get applications.argoproj.io -n argocd -o jsonpath='{range .items[*]}{.metadata.name}{\"  sync=\"}{.status.sync.status}{\" health=\"}{.status.health.status}{\"\\n\"}{end}'"
```
**Usar para:** Monitorar em tempo real durante sync

### Terminal 3: Logs (Opcional)
```bash
kubectl logs -n analytics-service -f deployment/analytics-service-deployment
```
**Usar para:** Ver logs da aplicação durante deployment

---

## 🎬 Demo en Vivo (20 minutos)

### [0:00-2:00] INTRO & CONTEXTO
- [ ] Apresentar a plataforma
- [ ] Mostrar diagrama (ARCHITECTURE.md)
- [ ] Explicar o problema que resolve

**Script:**
> "Essa plataforma é uma solução completa de Feature Flags com:
> - Infraestrutura como Código (Terraform)
> - DevSecOps Pipeline automatizado
> - GitOps com ArgoCD
> - 5 microserviços Kubernetes"

### [2:00-6:00] ESTÁGIO 1: TERRAFORM
- [ ] Mostrar estrutura modular
- [ ] Rodar `terraform validate`
- [ ] Mostrar `terraform plan`
- [ ] Listar recursos criados na AWS
- [ ] Explicar cada módulo brevemente

**Comandos:**
```bash
# 1. Estrutura
tree -L 2 Terraform/modules/

# 2. Validar
cd Terraform/live/global
terraform validate

# 3. Plan
terraform plan -out=/tmp/tfplan
terraform show /tmp/tfplan | head -30

# 4. AWS Resources
kubectl cluster-info
kubectl get nodes
aws rds describe-db-instances --query 'DBInstances[].DBInstanceIdentifier' --output table
```

### [6:00-10:00] ESTÁGIO 2: SECURITY FAIL
- [ ] Ir para `Microservices/analytics-service`
- [ ] Adicionar dependência vulnerável
- [ ] Fazer commit e push
- [ ] Air para GitHub Actions
- [ ] Mostrar pipeline executando
- [ ] Demonstrar falha na segurança

**Comandos:**
```bash
# 1. Ir para o serviço
cd Microservices/analytics-service

# 2. Backup original
cp requirements.txt requirements.txt.backup

# 3. Adicionar dependência vulnerável
echo "" >> requirements.txt
echo "# ⚠️ DEMO: Versão vulnerável" >> requirements.txt
echo "requests==2.6.0" >> requirements.txt

# 4. Mostrar conteúdo
cat requirements.txt

# 5. Commit
git add requirements.txt
git commit -m "⚠️ [DEMO] Add outdated dependency - will fail security checks"

# 6. Push (dispara pipeline)
git push origin main

# 7. Acessar GitHub Actions
# https://github.com/SEU_REPO/actions
```

**O que Mostrar:**
- Workflow iniciando
- Security scan rodando
- Trivy detectando vulnerabilidades
- ❌ Job failing antes de push para ECR

**Tempo de Espera:** ~3-5 min para pipeline completar

### [10:00-14:00] ESTÁGIO 3: SECURITY PASS
- [ ] Voltar ao arquivo
- [ ] Remover a dependência vulnerável
- [ ] Fazer novo commit
- [ ] Push novamente
- [ ] Mostrar pipeline passando
- [ ] Ver imagem sendo pushada para ECR

**Comandos:**
```bash
# 1. Restaurar versão original
mv requirements.txt.backup requirements.txt

# 2. Verificar conteúdo
cat requirements.txt | tail -3

# 3. Novo commit
git add requirements.txt
git commit -m "🔧 FIX: Update dependencies to secure versions"

# 4. Push novamente
git push origin main

# 5. Monitorar pipeline
# https://github.com/SEU_REPO/actions
```

**O que Mostrar:**
- ✅ Security checks passando
- ✅ Build succeeded
- ✅ Image pushed to ECR
- ✅ SBOM generated
- ✅ GitOps manifest updated

**Tempo de Espera:** ~3-5 min

### [14:00-18:00] ESTÁGIO 4: GITOPS + ARGOCD
- [ ] Ver o commit que atualizou a imagem
- [ ] Mostrar mudança no GitOps
- [ ] ArgoCD detectando
- [ ] Forçar sync se necessário
- [ ] Mostrar novo pod rodando
- [ ] Confirmar Synced + Healthy

**Comandos:**
```bash
# 1. Ver commit que atualizou imagem
git log --oneline -3

# 2. Ver mudança específica
git show HEAD:GitOps/analytics-service/deployment.yml | grep -A 2 "image:"

# 3. Status ArgoCD (Terminal 2)
watch -n 2 "kubectl get applications.argoproj.io -n argocd -o jsonpath='{range .items[*]}{.metadata.name}{\"  \"}{.status.sync.status}{\" - \"}{.status.health.status}{\"\\n\"}{end}'"

# 4. Forçar hard refresh se necessário
kubectl patch application analytics-service -n argocd -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}' --type merge

# 5. Ver pods atualizando (Terminal 3)
kubectl get pods -n analytics-service -w

# 6. Ver logs
kubectl logs -n analytics-service -f deployment/analytics-service-deployment

# 7. Verificação final
kubectl get deploy -n analytics-service
kubectl get applications.argoproj.io -n argocd -o wide
```

**O que Mostrar:**
- Git commit com nova tag
- ArgoCD detectando mudança
- Status passando de `OutOfSync` → `Syncing` → `Synced`
- Health passando de `Progressing` → `Healthy`
- Pod antigo sendo terminado
- Novo pod rodando
- Logs da aplicação iniciando normalmente

**Tempo de Espera:** ~2-3 min

### [18:00-20:00] CONCLUSÃO
- [ ] Resumir os 4 estágios
- [ ] Enfatizar a automatização
- [ ] Perguntas do público

**Script:**
> "O que vimos:
> 1. **Terraform** - Toda infraestrutura declarativa e versionada
> 2. **DevSecOps** - Segurança em cada passo, pipeline falha em caso de vulnerabilidade
> 3. **GitOps** - Código define estado, commits disparam deployments
> 4. **ArgoCD** - Sincronização automática, cluster sempre alinhado com Git
> 
> Tudo automatizado, rastreável e confiável!"

---

## 🔧 Troubleshooting Durante a Demo

### Pipeline não disparou
- [ ] Verificar GitHub Actions está habilitado
- [ ] Verificar branch proteção (se houver)
- [ ] Fazer manual trigger: workflow dispatch

### ArgoCD não sincronizou
- [ ] Forçar hard refresh
- [ ] Verificar git push foi bem-sucedido
- [ ] Aguardar até 2 minutos

### Pod não ficou Ready
- [ ] Ver logs: `kubectl logs -n <ns> <pod>`
- [ ] Descrever: `kubectl describe pod -n <ns> <pod>`
- [ ] Possíveis causas: Image pulling, secrets não encontrados

### Erro de conexão Git
- [ ] Verificar histórico: `git log`
- [ ] Fazer reset se necessário: `git reset --hard origin/main`
- [ ] Verificar credenciais Git

---

## 🎥 Recording Tips

If recording video:
- [ ] Use OBS Studio ou tool similar
- [ ] Zoom: 125-150% para melhor visualização
- [ ] Terminal font size: 16pt+ 
- [ ] Cor de fundo: dark (melhor para video)
- [ ] Gravar em 1080p 60fps
- [ ] Use speaker notes ou cue cards

---

## 🧹 Cleanup Após Demo

```bash
# 1. Revert demo changes
cd Microservices/analytics-service
git reset --hard origin/main

# 2. Verificar que está clean
git status  # deve estar clean

# 3. Voltar para root
cd ../../..

# 4. Garantir que tudo está sincronizado
kubectl get applications.argoproj.io -n argocd  # Tudo deve estar Synced/Healthy
```

---

## 📝 Notas Importantes

### ⚠️ Antes da Demo
- Testar TUDO em um environment de staging/dev
- Fazer backup do estado git
- Ter conexão internet estável
- Ter power bank carregado
- Silenciar notificações

### ⚠️ Durante a Demo
- Ir devagar, falar claro
- Pausar entre estágios
- Permitir perguntas
- Ter terminal e navegador abertos (mais rápido)
- Evitar muito typing (pre-script)

### ⚠️ Após a Demo
- Fazer cleanup dos commits demo
- Reset branch para estado limpo
- Documentar feedback
- Testar que tudo continua funcionando

---

## 📞 Suporte Rápido

**Problema:** Algo deu errado durante a demo?

1. **Não entre em pânico** - Público entende problemas técnicos
2. **Explique o que aconteceu** - "X faltou, então Y não happened"
3. **Mostre comando** - Demonstre como você debugaria
4. **Tenha fallback** - Se tudo falhar, mostrar screenshots/video

---

## ✅ Dia da Apresentação

### 30 min antes
- [ ] Testar kubeconfig
- [ ] Testar internet
- [ ] Testar projetor/monitor
- [ ] Testar som (se apresentando para grupo)
- [ ] Abrir terminais e preparar
- [ ] Fazer uma "dry run" rápida

### 5 min antes
- [ ] Silenciar notificações
- [ ] Fechar apps desnecessários
- [ ] Ter todos os terminais prontos
- [ ] Ter documentação aberta para referência
- [ ] Deep breath - você vai mandar bem!

---

## 🎉 Sucesso!

Se você foi através de todo este checklist e seguiu os passos, sua demonstração foi um sucesso! 

**Pontos-chave para lembrar:**
- ✅ Terraform: Infraestrutura declarativa
- ✅ DevSecOps: Segurança é não-negociável
- ✅ GitOps: Git é source of truth
- ✅ ArgoCD: Automação e sincronização

**Próximas vezes será mais rápido!** 🚀

---

**Dúvidas?** Revise [DEMO_GUIDE.md](DEMO_GUIDE.md) ou [ARCHITECTURE.md](ARCHITECTURE.md)
