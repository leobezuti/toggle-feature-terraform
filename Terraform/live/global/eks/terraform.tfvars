cluster_name = "toggle-feature-eks-cluster"
subnet_ids = module.global_vpc.private_subnet_ids_list

enable_elastic_load_balancing = false

node_group_name = "toggle-feature-node"

desired_size = 1
min_size = 1
max_size = 1
