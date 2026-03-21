# 🏛️ Arquitetura - Toggle Feature Platform

## 📐 Visão Geral da Arquitetura

```
┌─────────────────────────────────────────────────────────────────┐
│                     AWS CLOUD (us-east-1)                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │                   VPC (10.0.0.0/16)                       │ │
│  │                                                           │ │
│  │  ┌──────────────────┐         ┌──────────────────────┐  │ │
│  │  │  Public Subnet   │────────►│  Internet Gateway    │  │ │
│  │  │  (Ingress)       │         └──────────────────────┘  │ │
│  │  └──────┬───────────┘                                   │ │
│  │         │ NAT                                            │ │
│  │         │                                                │ │
│  │  ┌──────▼───────────────────────────────────────────┐  │ │
│  │  │        Private Subnets (EKS Cluster)            │  │ │
│  │  │                                                 │  │ │
│  │  │  ┌────────┐    ┌────────┐    ┌────────┐      │  │ │
│  │  │  │ Node 1 │    │ Node 2 │    │ Node N │      │  │ │
│  │  │  │ (t3.m) │    │ (t3.m) │    │ (t3.m) │      │  │ │
│  │  │  └────┬───┘    └────┬───┘    └────┬───┘      │  │ │
│  │  │       │             │             │           │  │ │
│  │  │ ┌─────┴─────────────┴─────────────┴────┐    │  │ │
│  │  │ │      Kubernetes Cluster (EKS)       │    │  │ │
│  │  │ │                                      │    │  │ │
│  │  │ │ ┌──────────────────────────────┐   │    │  │ │
│  │  │ │ │  ArgoCD (GitOps Controller)  │   │    │  │ │
│  │  │ │ └──────────────────────────────┘   │    │  │ │
│  │  │ │                                      │    │  │ │
│  │  │ │ ┌──────────────┐ ┌──────────────┐  │    │  │ │
│  │  │ │ │ Namespaces   │ │ Services     │  │    │  │ │
│  │  │ │ │              │ │              │  │    │  │ │
│  │  │ │ │ analysis     │ │ Endpoints    │  │    │  │ │
│  │  │ │ │ auth         │ │ ConfigMaps   │  │    │  │ │
│  │  │ │ │ evaluation   │ │ Secrets      │  │    │  │ │
│  │  │ │ │ flag         │ │ PVCs         │  │    │  │ │
│  │  │ │ │ targeting    │ │              │  │    │  │ │
│  │  │ │ └──────────────┘ └──────────────┘  │    │  │ │
│  │  │ └──────────────────────────────────────┘    │  │ │
│  │  │                                              │  │ │
│  │  └──────────────────────────────────────────────┘  │ │
│  │                                                    │ │
│  │  ┌─────────────────────────────────────────────┐ │ │
│  │  │        AWS Managed Services                │ │ │
│  │  │                                             │ │ │
│  │  │  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  │ │ │
│  │  │  │ RDS  │  │Redis │  │ SQS  │  │DynoD │  │ │ │
│  │  │  │ Auth │  │Cache │  │Queue │  │  DB  │  │ │ │
│  │  │  │      │  │      │  │      │  │      │  │ │ │
│  │  │  └──────┘  └──────┘  └──────┘  └──────┘  │ │ │
│  │  │                                             │ │ │
│  │  └─────────────────────────────────────────────┘ │ │
│  │                                                   │ │
│  └───────────────────────────────────────────────────┘ │
│                                                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │         ECR (Container Registry)                 │ │
│  │  - analytics-service                             │ │
│  │  - auth-service                                  │ │
│  │  - evaluation-service                            │ │
│  │  - flag-service                                  │ │
│  │  - targeting-service                             │ │
│  └───────────────────────────────────────────────────┘ │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🔄 Pipeline CI/CD/DevSecOps

```
┌─────────────────────────────────────────────────────────────────┐
│                GitHub (Source Code Repository)                │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼ (push event)
       ┌─────────────────────────────┐
       │  GitHub Actions Triggered   │
       └────────────┬────────────────┘
                    │
         ┌──────────┴─────────────┐
         │                        │
         ▼                        ▼
   ┌──────────────┐        ┌──────────────────┐
   │ 1. Checkout  │        │ 2. Detect        │
   │ Code         │        │    Changed       │
   │              │        │    Services      │
   └──────────────┘        └──────────────────┘
         │                        │
         └──────────┬─────────────┘
                    │
         ┌──────────▼──────────┐
         │ 3. SECURITY SCANNING│
         │    (Parallel)       │
         └──────┬──┬──┬───┬───┘
                │  │  │   │
    ┌───────────┘  │  │   │
    │              │  │   │
    ▼              ▼  ▼   ▼
 ┌──────────┐  ┌──────────┐
 │GitGuard  │  │Bandit    │
 │(Secrets) │  │(SAST)    │
 └──────────┘  └──────────┘
    ┌──────────┐  ┌──────────┐
    │Safety    │  │gosec     │
    │(Deps)    │  │(SAST Go) │
    └──────────┘  └──────────┘

         ┌──────────┐
         │ All Pass?│
         └──────┬───┘
                │
      ┌─────────┴──────────┐
      │                    │
      ▼ YES               ▼ NO
  ┌────────────────┐   ┌──────────┐
  │ 4. Build Image │   │ FAIL     │
  │ (Docker)       │   │ Pipeline │
  └────────┬───────┘   └──────────┘
           │
           ▼
  ┌────────────────┐
  │ 5. Scan Image  │
  │ (Trivy)        │
  │ CVE Database   │
  └────────┬───────┘
           │
           ▼
  ┌────────────────┐
  │ Pass CRITICAL? │
  └────────┬───────┘
           │
      ┌────┴───┐
      ▼        ▼
     YES      NO
      │        │
      │        ▼
      │    ┌──────────┐
      │    │ FAIL     │
      │    │ Pipeline │
      │    └──────────┘
      │
      ▼
  ┌────────────────┐
  │ 6. Generate    │
  │ SBOM (Syft)    │
  └────────┬───────┘
           │
           ▼
  ┌────────────────┐
  │ 7. Push to ECR │
  └────────┬───────┘
           │
           ▼
  ┌────────────────────────┐
  │ 8. Update GitOps Repo  │
  │ (Update image tag)     │
  └────────┬───────────────┘
           │
           ▼ (git push)
  ┌─────────────────────────┐
  │ GitOps Repository       │
  │                         │
  │ GitOps/                 │
  │ ├── analytics-svc/      │
  │ │   └── deployment.yml  │
  │ ├── auth-svc/           │
  │ ├── evaluation-svc/     │
  │ ├── flag-svc/           │
  │ └── targeting-svc/      │
  └────────┬────────────────┘
           │
           ▼ (watched by ArgoCD)
  ┌─────────────────────────┐
  │ ArgoCD                  │
  │ 1. Detect changes       │
  │ 2. Sync status          │
  │ 3. Apply manifests      │
  └────────┬────────────────┘
           │
           ▼
  ┌─────────────────────────┐
  │ Kubernetes Cluster      │
  │ 1. Pull new image       │
  │ 2. Create pod           │
  │ 3. Health checks        │
  │ 4. Route traffic        │
  └─────────────────────────┘
```

---

## 🏃 Microserviços

### 1. **Analytics Service** (Python)
- **Porta:** 5001
- **Função:** Coleta e processa eventos de feature flags
- **Dependências:** 
  - AWS SQS (fila de mensagens)
  - AWS DynamoDB (armazenamento de eventos)
  - AWS KMS (criptografia)
- **Database:** Não usa RDS
- **Endpoints:**
  - `GET /health` - Health check
  - `POST /event` - Registrar evento

### 2. **Auth Service** (Go)
- **Porta:** 5010
- **Função:** Autenticação e autorização
- **Dependências:**
  - PostgreSQL (RDS auth-db)
- **Database:** RDS PostgreSQL (auth-db)
- **Endpoints:**
  - `GET /health` - Health check
  - `POST /auth/login` - Login
  - `POST /auth/validate` - Validar token

### 3. **Flag Service** (Python)
- **Porta:** 5002
- **Função:** Gerenciamento de feature flags
- **Dependências:**
  - PostgreSQL (RDS flag-db)
  - Auth Service
- **Database:** RDS PostgreSQL (flag-db)
- **Endpoints:**
  - `GET /health` - Health check
  - `GET /flags` - Listar flags
  - `POST /flags` - Criar flag
  - `PUT /flags/{id}` - Atualizar flag

### 4. **Targeting Service** (Python)
- **Porta:** 5003
- **Função:** Segmentação e direcionamento
- **Dependências:**
  - PostgreSQL (RDS targeting-db)
  - Auth Service
- **Database:** RDS PostgreSQL (targeting-db)
- **Endpoints:**
  - `GET /health` - Health check
  - `GET /segments` - Listar segmentos
  - `POST /segments` - Criar segmento

### 5. **Evaluation Service** (Go)
- **Porta:** 5004
- **Função:** Avaliação de flags em tempo real
- **Dependências:**
  - Redis (ElastiCache)
  - AWS SQS
  - Flag Service
  - Targeting Service
- **Database:** Nenhum (usa Redis cache)
- **Endpoints:**
  - `GET /health` - Health check
  - `POST /evaluate` - Avaliar flag

---

## 🔐 Comunicação Entre Serviços

```
User/Client
    │
    ▼
ingress-nginx (LoadBalancer)
    │
    ├─────────────────────┬───────────────┬──────────────┤
    │                     │               │              │
    ▼                     ▼               ▼              ▼
Flag-Svc              Auth-Svc      Targeting-Svc   Evaluation-Svc
(Port 5002)           (Port 5010)   (Port 5003)     (Port 5004)
    │                     │               │
    ├──────────┬──────────┤               │
    │          │          │               │
    ▼          ▼          ▼               ▼
RDS flag-db  RDS auth-db  RDS targeting-db  Redis Cache
          │
          ▼
    Analytics-Svc
    (Port 5001)
          │
          ├─────────┬─────────┐
          ▼         ▼         ▼
        SQS      DynamoDB    KMS
```

---

## 📊 Data Flow (Feature Flag Evaluation)

```
1. Client Request
   GET /evaluate?flag=new_feature&userId=123

2. Evaluation Service
   ├─ Check Redis cache for user segment
   ├─ If miss: Query Targeting Service
   ├─ Get user segment from Database
   ├─ Call Flag Service to get flag config
   └─ Evaluate rule (user in segment?)

3. Response
   {
     "flag": "new_feature",
     "enabled": true,
     "variant": "control"  // ou "treatment"
   }

4. Analytics (Async via SQS)
   - Message queued to evaluation-queue
   - Analytics Service picks up
   - Stores to DynamoDB
```

---

## 🔗 GitOps Flow

```
1. Developer push code
   git push origin main (Microservices/)
   │
   └─► GitHub Actions triggers
       ├─ Security Scans
       ├─ Build Docker Image
       ├─ Scan Image
       └─ Push to ECR

2. Update GitOps Repo
   Workflow commits new image tag
   git push origin main (GitOps/)
   │
   └─► GitHub receives push

3. ArgoCD Webhook
   ArgoCD detects git push
   ├─ Git sync
   ├─ Manifest comparison
   └─ Diff detection

4. Auto Sync (if enabled)
   ├─ kubectl apply new manifests
   ├─ Kubernetes reconciles
   ├─ New pods created
   ├─ Old pods terminated
   └─ Service updated

5. Monitoring
   ArgoCD watches cluster state
   ├─ Pod - Running? ✅
   ├─ Health - OK? ✅
   └─ Sync - Latest? ✅
```

---

## 📈 Kubernetes Resources

### Namespaces
```
- analytics-service       (Analytics pods)
- auth-service            (Auth pods)
- evaluation-service      (Evaluation pods)
- flag-service            (Flag pods)
- targeting-service       (Targeting pods)
- argocd                  (ArgoCD)
- ingress-nginx           (Ingress)
- kube-system             (System)
```

### Per-Service Resources
```
Each service has:
├─ Deployment            (Pod replicas)
├─ Service               (ClusterIP/LoadBalancer)
├─ Ingress               (External access)
├─ ConfigMap             (Config)
├─ Secret                (Credentials)
├─ ServiceAccount        (RBAC)
├─ Role                  (Permissions)
└─ RoleBinding           (Assign role)
```

### High Availability
```
- Multiple replicas per service
- Pod Disruption Budgets
- Multi-AZ deployment
- Auto-scaling (HPA)
- Load balancing
```

---

## 🔐 Security Layers

```
1. Network Level
   ├─ VPC isolation
   ├─ Security Groups
   ├─ Network Policies
   └─ WAF (no AWS ALB)

2. Container Level
   ├─ Image scanning (Trivy)
   ├─ Runtime security
   ├─ RBAC
   └─ Pod security policies

3. Application Level
   ├─ Secret management
   ├─ Input validation
   ├─ Rate limiting
   └─ API authentication

4. Data Level
   ├─ Encryption at rest (KMS)
   ├─ Encryption in transit (TLS)
   ├─ Database authentication
   └─ Audit logging
```

---

## 📞 Communication Patterns

### Synchronous (HTTP/REST)
```
Flag Service <--> Targeting Service
Flag Service <--> Auth Service
Evaluation Service <--> Flag Service
Evaluation Service <--> Targeting Service
```

### Asynchronous (SQS Queue)
```
Analytics Service --> SQS Queue
Evaluation Service --> SQS Queue
  └─> Analytics Service processes
```

### Cache (Redis)
```
Evaluation Service --> Redis
  (user segment cache)
```

---

## 📊 Monitoring & Observability

### Metrics Collected
```
- Pod CPU/Memory usage
- Request latency
- Error rates
- Queue depth (SQS)
- Database connections
- Cache hit rate
```

### Logs Aggregation
```
All pod logs available via:
kubectl logs -n <namespace> <pod>
```

### Health Checks
```
Liveness Probe:   Is pod alive?  (restart if dead)
Readiness Probe:  Ready to serve? (remove from LB if not)
Startup Probe:    App initialized? (wait before other probes)
```

---

## 🚀 Deployment Strategies

### Current: Rolling Update
```
1. Start new pod (new image)
2. Wait for ready
3. Route traffic to new
4. Scale down old
5. Repeat for each replica
```

### Alternative: Blue-Green
```
1. Deploy green (new version)
2. Test green
3. Switch traffic at once
4. Keep blue as rollback
```

### Alternative: Canary
```
1. Deploy canary (5% traffic)
2. Monitor metrics
3. Increase to 25%, 50%, 100%
4. Or rollback if issues
```

---

## 📈 Scaling Decisions

### Horizontal Scaling (HPA)
```
Trigger: CPU > 70%
Min pods: 1
Max pods: 10
Scale up: Add 2 pods
Scale down: Remove 1 pod after 5 min idle
```

### Vertical Scaling
```
Requests:
  - CPU: 100m
  - Memory: 128Mi

Limits:
  - CPU: 500m
  - Memory: 512Mi
```

---

## 🔄 Disaster Recovery

### Backup Strategy
```
- RDS: Automated daily, 30-day retention
- DynamoDB: Point-in-time recovery
- Git: Complete history in GitHub
- Kubernetes: Manifests in GitOps repo
```

### Recovery Time Objective (RTO)
```
- Pod failure: < 1 minute
- Node failure: < 5 minutes
- Zone failure: < 10 minutes
- Database restore: ~5 minutes
```

---

## 📚 Referências

- [Kubernetes Docs](https://kubernetes.io/docs/)
- [ArgoCD Docs](https://argo-cd.readthedocs.io/)
- [AWS EKS Best Practices](https://docs.aws.amazon.com/eks/latest/userguide/)
- [12 Factor App](https://12factor.net/)
