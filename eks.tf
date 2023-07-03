module "eks-cluster" {
  source                             = "./tf-modules/eks"
  env                                = local.env
  project                            = local.project
  subnet-ids                         = ["subnet-033e1d9428f91f483", "subnet-04ebd429464000948"]
  #security_groups = [aws_security_group.eks-master.id]
  tags                               = merge(tomap({"Name" = join("-", [local.env, local.project, "eks-cluster"])}), tomap({"ResourceType" = "EKS-cluster-resource"}), local.common_tags)
  eks-version                        = local.eks-version
  vpc_id                             = "vpc-0194d1b660005a311"
  vpc-cidr-block                     = "10.144.160.0/20"
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
    certificate-authority-data: ${module.eks-cluster.eks_certificate_authority.0.data}
    server: ${module.eks-cluster.eks_endpoint}
  name: ${module.eks-cluster.eks_arn}
contexts:
- context:
    cluster: ${module.eks-cluster.eks_arn}
    user: ${module.eks-cluster.eks_arn}
  name: ${module.eks-cluster.eks_arn}
current-context: ${module.eks-cluster.eks_arn}
kind: Config
preferences: {}
users:
- name: ${module.eks-cluster.eks_arn}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - ap-southeast-1
      - eks
      - get-token
      - --cluster-name
      - "${module.eks-cluster.cluster_name}"
      - --output
      - json
      command: aws
KUBECONFIG
}





resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = <<BASH
FILE=$HOME/.kube/config
if test -f "$FILE"; then
    echo "kubeconfig is ok"
    echo "${local.kubeconfig}" > $HOME/.kube/config
else
    mkdir $HOME/.kube/
    echo "${local.kubeconfig}" > $HOME/.kube/config
fi
BASH
  }
}

# # EKS IRSA 
# module "iam_iam-role-for-service-accounts-eks" {
#   source                             = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version                            = "5.20.0"
#   role_name                          = "${local.env}_${local.project}_karpenter_controller_EKS"
#   role_policy_arns = {
#     policy = aws_iam_policy.karpenter_controller_policy.arn
#   }
#   attach_karpenter_controller_policy = true

#   karpenter_controller_cluster_name  = module.eks-cluster.cluster_name
#   karpenter_controller_node_iam_role_arns = [module.eks-iam.aws_iam_role_arn]

#   attach_vpc_cni_policy = true
#   vpc_cni_enable_ipv4   = true

#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks-cluster.openID_connect_arn
#       namespace_service_accounts = ["karpenter:karpenter"]
#     }
#   }
# }
