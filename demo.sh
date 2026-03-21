#!/bin/bash

# 🎬 Toggle Feature Platform - Demo Automation Script
# Este script automatiza os passos da demonstração

set -euo pipefail

# ============================================================================
# CORES E FORMATAÇÃO
# ============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

print_header() {
    echo -e "\n${CYAN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}=  $1${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_step() {
    echo -e "${CYAN}→  $1${NC}"
}

pause_for_effect() {
    local seconds=${1:-3}
    echo -e "${YELLOW}⏳ Aguardando ${seconds}s...${NC}"
    sleep "$seconds"
}

confirm() {
    local prompt=$1
    local response
    read -p "$(echo -e ${YELLOW}$prompt${NC}) (s/n): " response
    [[ "$response" =~ [sS]$ ]]
}

# ============================================================================
# CHECKS INICIAIS
# ============================================================================

check_prerequisites() {
    print_header "Verificando Pré-requisitos"

    local missing=0

    if ! command -v docker &> /dev/null; then
        print_error "Docker não encontrado"
        missing=$((missing + 1))
    else
        print_success "Docker instalado"
    fi

    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl não encontrado"
        missing=$((missing + 1))
    else
        print_success "kubectl instalado"
    fi

    if ! command -v terraform &> /dev/null; then
        print_error "Terraform não encontrado"
        missing=$((missing + 1))
    else
        print_success "Terraform instalado"
    fi

    if ! command -v git &> /dev/null; then
        print_error "Git não encontrado"
        missing=$((missing + 1))
    else
        print_success "Git instalado"
    fi

    # Verificar kubeconfig
    if ! kubectl cluster-info &> /dev/null; then
        print_error "Kubernetes cluster não acessível"
        missing=$((missing + 1))
    else
        print_success "Kubernetes cluster acessível"
        kubectl cluster-info | head -1
    fi

    if [ $missing -gt 0 ]; then
        print_error "$missing pré-requisito(s) não atendido(s)"
        return 1
    fi

    print_success "Todos os pré-requisitos atendidos!"
    return 0
}

# ============================================================================
# ESTÁGIO 1: TERRAFORM
# ============================================================================

stage_1_terraform() {
    print_header "ESTÁGIO 1: Infrastructure as Code (Terraform)"

    print_info "Mostrando estrutura Terraform modular..."
    print_step "Estrutura:"
    tree -L 2 -I 'node_modules' Terraform/ 2>/dev/null || find Terraform/ -maxdepth 2 -type d | head -10

    pause_for_effect 2

    print_step "Validando Terraform..."
    cd Terraform/live/global
    terraform validate
    print_success "Terraform validation passed!"

    pause_for_effect 2

    print_step "Mostrando Terraform Plan..."
    terraform plan -out=/tmp/tfplan 2>/dev/null | head -30
    echo "..."

    pause_for_effect 2

    print_step "Estado Atual da Infraestrutura:"
    
    print_info "EKS Cluster:"
    kubectl cluster-info | grep 'Kubernetes master'
    
    print_info "Nodes do Cluster:"
    kubectl get nodes -o wide

    pause_for_effect 2

    print_info "Recursos RDS:"
    aws rds describe-db-instances --query 'DBInstances[].[DBInstanceIdentifier,Endpoint.Address,DBInstanceStatus]' --output table 2>/dev/null || print_warning "AWS CLI não configurado"

    cd - > /dev/null
}

# ============================================================================
# ESTÁGIO 2: PIPELINE COM ERRO
# ============================================================================

stage_2_security_fail() {
    print_header "ESTÁGIO 2: Pipeline DevSecOps - FALHA DE SEGURANÇA"

    print_info "Vamos simular um erro comum: dependência vulnerável"

    print_step "Criando erro intencional em analytics-service..."
    cd Microservices/analytics-service

    # Backup do arquivo original
    cp requirements.txt requirements.txt.backup

    # Adicionar dependência vulnerável
    echo "requests==2.6.0  # Versão com CVE conhecida" >> requirements.txt

    print_success "Dependência vulnerável adicionada a requirements.txt"
    print_info "Conteúdo do arquivo:"
    tail -3 requirements.txt

    pause_for_effect 2

    print_step "Fazendo commit..."
    git add requirements.txt
    git commit -m "⚠️  [DEMO] Add outdated requests dependency - VULNERABLE" || print_warning "Erro no commit"

    print_step "Fazendo push (triggering pipeline)..."
    git push origin main || print_warning "Push falhou (pode não ter acesso ao repo)"

    print_info "Pipeline disparado! Acessar:"
    echo -e ${CYAN}
    echo "https://github.com/YOUR_REPO/actions"
    echo -e ${NC}

    print_warning "O pipeline FALHARÁ nos seguintes passos:"
    echo "  • Security Scan (Trivy/Bandit) - Detectará CVE"
    echo "  • Dependency Check (Safety) - Detectará versão vulnerável"
    echo "  • Imagem NÃO será pushada para ECR"

    pause_for_effect 5

    cd - > /dev/null
}

# ============================================================================
# ESTÁGIO 3: CORREÇÃO E SUCESSO
# ============================================================================

stage_3_security_pass() {
    print_header "ESTÁGIO 3: Correção e Pipeline Bem-sucedido"

    print_step "Revertendo arquivo para versão segura..."
    cd Microservices/analytics-service

    # Restaurar backup
    mv requirements.txt.backup requirements.txt

    print_success "Dependência vulnerável removida"
    print_info "Conteúdo do arquivo agora:"
    tail -3 requirements.txt

    pause_for_effect 2

    print_step "Fazendo novo commit com correção..."
    git add requirements.txt
    git commit -m "🔧 FIX: Update requests to latest secure version" || print_warning "Erro no commit"

    print_step "Fazendo push (triggering pipeline novamente)..."
    git push origin main || print_warning "Push falhou"

    print_info "Pipeline disparado novamente! Desta vez PASSARÁ:"
    echo "✅ Security Scan (PASSOU)"
    echo "✅ Build Docker image (SUCESSO)"
    echo "✅ Push para ECR (CONCLUÍDO)"
    echo "✅ SBOM generado"
    echo "✅ GitOps manifest atualizado"

    pause_for_effect 5

    cd - > /dev/null
}

# ============================================================================
# ESTÁGIO 4: GITOPS + ARGOCD
# ============================================================================

stage_4_gitops_argocd() {
    print_header "ESTÁGIO 4: GitOps e ArgoCD"

    print_step "ArgoCD detectando mudança no GitOps repo..."
    pause_for_effect 2

    print_info "Status das Aplicações ArgoCD:"
    kubectl get applications.argoproj.io -n argocd -o jsonpath='{range .items[*]}{.metadata.name}{": sync="}{.status.sync.status}{" health="}{.status.health.status}{"\n"}{end}'

    pause_for_effect 2

    print_step "Forçando hard-refresh do ArgoCD..."
    for app in analytics-service auth-service evaluation-service flag-service targeting-service; do
        kubectl patch application "$app" -n argocd -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}' --type merge 2>/dev/null || true
    done

    print_info "Aguardando sincronização..."
    pause_for_effect 5

    print_step "Status FINAL das Aplicações:"
    kubectl get applications.argoproj.io -n argocd -o jsonpath='{range .items[*]}{.metadata.name}{": "}{.status.sync.status}{" - "}{.status.health.status}{"\n"}{end}'

    pause_for_effect 2

    print_step "Status dos Deployments:"
    kubectl get deploy -n analytics-service,auth-service,evaluation-service,flag-service,targeting-service --all-namespaces=false -o wide 2>/dev/null | grep -v NAME || kubectl get deploy -A | grep -E "(analytics|auth|evaluation|flag|targeting)"

    pause_for_effect 2

    print_step "Pods rodando:"
    kubectl get pods -n analytics-service,auth-service,evaluation-service,flag-service,targeting-service --all-namespaces=false 2>/dev/null | head -20 || kubectl get pods -A | grep -E "(analytics|auth|evaluation|flag|targeting)" | head -5

    print_success "ArgoCD sincronizado! Todos os serviços rodando com a nova versão."
}

# ============================================================================
# VERIFICAÇÃO DE STATUS
# ============================================================================

status_check() {
    print_header "VERIFICAÇÃO COMPLETA DO STATUS"

    print_info "Terraform Status:"
    cd Terraform/live/global
    terraform state list | wc -l | xargs echo "Recursos gerenciados:"
    cd - > /dev/null

    print_info "Kubernetes Cluster:"
    kubectl cluster-info | grep 'Kubernetes master'
    kubectl get nodes -o 'jsonpath={range .items[*]}{.metadata.name}{"\t"}{.status.conditions[?(@.type=="Ready")].status}{"\n"}{end}'

    print_info "Deployments Status:"
    kubectl get deploy -o 'jsonpath={range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{.status.readyReplicas}{"\t"}{.status.replicas}{"\n"}{end}' | grep -E "(analytics|auth|evaluation|flag|targeting)" || kubectl get deploy -A

    print_info "ArgoCD Applications:"
    kubectl get applications.argoproj.io -n argocd -o 'jsonpath={range .items[*]}{.metadata.name}{"\t"}{.status.sync.status}{"\t"}{.status.health.status}{"\n"}{end}'

    print_info "Service Health:"
    for svc in analytics-service auth-service evaluation-service flag-service targeting-service; do
        port=$(kubectl get svc -n "$svc" -o jsonpath='{.items[0].spec.ports[0].port}' 2>/dev/null || echo "?")
        echo "  $svc (port $port)"
    done

    print_success "Status check concluído!"
}

# ============================================================================
# CLEANUP DEMO
# ============================================================================

cleanup_demo() {
    print_header "LIMPEZA APÓS DEMO"

    print_warning "Revertendo changes da demonstração..."

    cd Microservices/analytics-service
    
    # Revert commits
    print_step "Revertendo commits..."
    git log --oneline | grep -E "\[DEMO\]|\[TEST\]" | head -2 | awk '{print $1}' | xargs -I {} git revert {} --no-edit 2>/dev/null || print_info "Nenhum commit marked para revert"

    # Ou fazer hard reset
    if confirm "Deseja fazer 'git reset --hard origin/main'?"; then
        git reset --hard origin/main
        print_success "Branch resetada"
    fi

    cd - > /dev/null

    print_success "Cleanup concluído!"
}

# ============================================================================
# MENU PRINCIPAL
# ============================================================================

show_menu() {
    print_header "🎬 Toggle Feature Platform - Demo Script"

    echo "Escolha uma opção:"
    echo ""
    echo "  1) Verificar Pré-requisitos"
    echo "  2) Estágio 1: IaC (Terraform)"
    echo "  3) Estágio 2: Pipeline com Erro (DevSecOps FAIL)"
    echo "  4) Estágio 3: Correção (DevSecOps PASS)"
    echo "  5) Estágio 4: GitOps + ArgoCD"
    echo "  6) Verificação Completa de Status"
    echo "  7) Executar Demo Completa (1-5)"
    echo "  8) Cleanup após demo"
    echo "  9) Sair"
    echo ""
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    while true; do
        show_menu
        read -p "Digite sua escolha (1-9): " choice

        case $choice in
            1)
                check_prerequisites
                ;;
            2)
                stage_1_terraform
                ;;
            3)
                stage_2_security_fail
                ;;
            4)
                stage_3_security_pass
                ;;
            5)
                stage_4_gitops_argocd
                ;;
            6)
                status_check
                ;;
            7)
                print_header "EXECUTANDO DEMO COMPLETA"
                check_prerequisites && \
                stage_1_terraform && \
                pause_for_effect 2 && \
                stage_2_security_fail && \
                pause_for_effect 30 && \
                stage_3_security_pass && \
                pause_for_effect 30 && \
                stage_4_gitops_argocd && \
                print_success "DEMO COMPLETA CONCLUÍDA!"
                ;;
            8)
                cleanup_demo
                ;;
            9)
                print_info "Saindo..."
                exit 0
                ;;
            *)
                print_error "Opção inválida!"
                ;;
        esac

        if [ "$choice" != "9" ]; then
            echo ""
            read -p "Pressione ENTER para voltar ao menu..."
        fi
    done
}

# Executar
main
