terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github_actions" {
  count = var.github_oidc_provider_arn == "" ? 1 : 0

  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

locals {
  github_oidc_provider_arn = var.github_oidc_provider_arn != "" ? var.github_oidc_provider_arn : aws_iam_openid_connect_provider.github_actions[0].arn
}

resource "aws_iam_role" "github_actions" {
  name = "toggle-feature-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = local.github_oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_repository}:ref:refs/heads/${var.github_branch}"
        }
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "github_actions_ecr" {
  name = "toggle-feature-github-actions-ecr-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:PutImage",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories"
        ]
        Resource = "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/*"
      }
    ]
  })
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubectl" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }
}

module "vpc" {
  source = "../../../modules/vpc"

  vpc_name           = var.vpc_name
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  enable_nat_gateway = var.enable_nat_gateway
  tags               = var.tags
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

module "eks" {
  source = "../../../modules/eks"

  cluster_name                   = var.cluster_name
  cluster_role_arn               = aws_iam_role.eks_cluster_role.arn
  subnet_ids                     = concat(values(module.vpc.public_subnet_ids), module.vpc.private_subnet_ids_list)
  enable_elastic_load_balancing  = var.enable_elastic_load_balancing
  node_role_arn                  = aws_iam_role.eks_node_role.arn
  desired_size                   = var.desired_size
  max_size                       = var.max_size
  min_size                       = var.min_size
  instance_type                  = var.instance_type
  capacity_type                  = "SPOT"
}

module "rds_auth" {
  source = "../../../modules/rds"

  project_name       = "auth-service"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids_list
  db_identifier      = "auth-db"
  db_engine_version  = "15"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  db_name            = "authdb"
  db_username        = "authuser"
  tags               = var.tags
}

module "rds_flag" {
  source = "../../../modules/rds"

  project_name       = "flag-service"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids_list
  db_identifier      = "flag-db"
  db_engine_version  = "15"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  db_name            = "flagdb"
  db_username        = "flaguser"
  tags               = var.tags
}

module "rds_targeting" {
  source = "../../../modules/rds"

  project_name       = "targeting-service"
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids_list
  db_identifier      = "targeting-db"
  db_engine_version  = "15"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  db_name            = "targetingdb"
  db_username        = "targetinguser"
  tags               = var.tags
}

module "redis" {
  source = "../../../modules/redis"

  cluster_name      = "toggle-feature-redis"
  engine            = "redis"
  engine_version    = "7.0"
  node_type         = "cache.t3.micro"
  parameter_group_name = "default.redis7"
  port              = 6379
  subnet_group_name = "redis-subnet-group"
  subnet_ids        = module.vpc.private_subnet_ids_list

  tags = var.tags
}

module "dynamodb" {
  source = "../../../modules/dynamodb"

  table_name     = "ToggleMasterAnalytics"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  hash_key_type  = "S"
  stream_specification = {
    stream_enabled   = false
    stream_view_type = null
  }
  ttl_attribute_name = null
  point_in_time_recovery_enabled = true
  tags = var.tags
}

module "sqs" {
  source = "../../../modules/sqs"

  queue_name                  = "evaluation-queue"
  delay_seconds               = 0
  max_message_size            = 262144
  message_retention_seconds   = 86400
  visibility_timeout_seconds  = 30
  receive_wait_time_seconds   = 0
  tags                        = var.tags
}

module "ecr" {
  source = "../../../modules/ecr"

  repository_names = [
    "auth-service",
    "flag-service",
    "evaluation-service",
    "targeting-service",
    "analytics-service"
  ]
  tags = var.tags
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true

  values = [
    yamlencode({
      server = {
        service = {
          type = "LoadBalancer"
        }
      }
    })
  ]
}

