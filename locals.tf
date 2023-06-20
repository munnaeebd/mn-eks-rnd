locals {

  #env         = terraform.workspace
  env         = "uat"
  owner       = "SE"
  cost-center = "munna"
  project     = "munna-rnd"
  version     = "0.0.1"
  account-id  = "051725806636"
  region      = "ap-southeast-1"
  common_tags = {
    Environment = local.env
    Version     = local.version
    Owner       = local.owner
    Cost-Center = local.cost-center
    Project     = local.project
  }


  tf_eks-version = {
    uat  = "1.23"
    sb   = "1.23"
    lt   = "1.23"
    prod = "1.23"
  }
  eks-version = local.tf_eks-version[local.env]
  tf_eks_ondemand_desired_size = {
    uat  = "0"
    prod = "0"
    sb   = "0"
    lt   = "0"
  }
  eks_ondemand_desired_size = local.tf_eks_ondemand_desired_size[local.env]
  tf_eks_ondemand_min_size = {
    uat  = "0"
    prod = "0"
    sb   = "0"
    lt   = "0"
  }
  eks_ondemand_min_size = local.tf_eks_ondemand_min_size[local.env]
  tf_eks_ondemand_max_size = {
    uat  = "0"
    prod = "0"
    sb   = "0"
    lt   = "0"
  }
  eks_ondemand_max_size = local.tf_eks_ondemand_max_size[local.env]
  tf_eks_spot_desired_size = {
    uat  = "2"
    prod = "0"
    sb   = "0"
    lt   = "0"
  }
  eks_spot_desired_size = local.tf_eks_spot_desired_size[local.env]
  tf_eks_spot_min_size = {
    uat  = "2"
    prod = "0"
    sb   = "0"
    lt   = "0"
  }
  eks_spot_min_size = local.tf_eks_spot_min_size[local.env]
  tf_eks_spot_max_size = {
    uat  = "2"
    prod = "0"
    sb   = "0"
    lt   = "0"
  }
  eks_spot_max_size = local.tf_eks_spot_max_size[local.env]
  tf_node_group_instance_types = {
    uat   = ["t3.medium","t3a.medium"]
    prod  = ["m5.xlarge","m5d.xlarge","m5a.xlarge","m5ad.xlarge","m5n.xlarge","m5dn.xlarge","m4.xlarge","t3a.xlarge"]
    sb    = ["t3.medium","t3a.medium"]
    lt    = ["m5.xlarge","m5d.xlarge","m5a.xlarge","m5ad.xlarge","m5n.xlarge","m5dn.xlarge","m4.xlarge","t3a.xlarge"]
  }
  node_group_instance_types = local.tf_node_group_instance_types[local.env]
}
