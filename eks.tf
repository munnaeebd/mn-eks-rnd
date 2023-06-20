module "eks-cluster" {
  source                             = "./tf-modules/eks"
  env                                = local.env
  project                            = local.project
  subnet-ids                         = ["subnet-97cbc8de", "subnet-aea0b3c9", "subnet-9631ffcf"]
  #security_groups = [aws_security_group.eks-master.id]
  tags                               = merge(tomap({"Name" = join("-", [local.env, local.project, "eks-cluster"])}), tomap({"ResourceType" = "EKS-cluster-resource"}), local.common_tags)
  eks-version                        = local.eks-version
  vpc_id                             = "vpc-38e7c95f"
  vpc-cidr-block                     = "172.31.0.0/16"
  worker_node_role_arn               = module.eks-iam.aws_iam_role_arn
  ondemand_desired_size              = local.eks_ondemand_desired_size
  ondemand_max_size                  = local.eks_ondemand_max_size
  ondemand_min_size                  = local.eks_ondemand_min_size
  spot_desired_size                  = local.eks_spot_desired_size
  spot_max_size                      = local.eks_spot_max_size
  spot_min_size                      = local.eks_spot_min_size
  node_group_instance_types          = local.node_group_instance_types
}

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${module.eks-iam.aws_iam_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${module.eks-cluster.eks_endpoint}
    certificate-authority-data: ${module.eks-cluster.eks_certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${module.eks-cluster.cluster_name}"
KUBECONFIG
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = <<BASH
FILE=$HOME/.kube/config
if test -f "$FILE"; then
    echo "kubeconfig is ok"
else
    mkdir $HOME/.kube/
    echo "${local.kubeconfig}" > $HOME/.kube/config
fi
BASH
  }
}

# EKS IRSA 
module "iam_iam-role-for-service-accounts-eks" {
  source                             = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                            = "5.20.0"
  role_name                          = "${local.env}_${local.project}_karpenter_controller_EKS"
  role_policy_arns = {
    policy = aws_iam_policy.karpenter_controller_policy.arn
  }
  attach_karpenter_controller_policy = true

  karpenter_controller_cluster_name  = module.eks-cluster.cluster_name
  karpenter_controller_node_iam_role_arns = [module.eks-iam.aws_iam_role_arn]

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks-cluster.openID_connect_arn
      namespace_service_accounts = ["karpenter:karpenter"]
    }
  }
}
