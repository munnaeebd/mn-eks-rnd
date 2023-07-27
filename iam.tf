module "eks-iam" {
  source = "./tf-modules/iam"
  name   = "${local.env}-${local.project}-worker"
  policies = {
    EKSDefaultPolicy            = aws_iam_policy.k8s-default-policy.arn
    AmazonSSMFullAccess         = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
    EKSWorkerPolicy             = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    ECRReadOnly                 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    EKSCNIPolicy                = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    SSMManagedInstanceCore      = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

resource "aws_iam_policy" "k8s-default-policy" {
  name   = "${local.env}-${local.project}-k8s-default-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:CreateNetworkInterfacePermission",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeInstances",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DetachNetworkInterface",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:ModifyNetworkInterfaceAttribute",
                "iam:ListAttachedRolePolicies",
                "eks:UpdateClusterVersion"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:vpc/*",
                "arn:aws:ec2:*:*:subnet/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "route53:AssociateVPCWithHostedZone",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:DescribeLogStreams"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/eks/*:*"
        },
        {
            "Effect": "Allow",
            "Action": "logs:PutLogEvents",
            "Resource": "arn:aws:logs:*:*:log-group:/aws/eks/*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "eks.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AssignPrivateIpAddresses",
                "ec2:AttachNetworkInterface",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeInstances",
                "ec2:DescribeTags",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeInstanceTypes",
                "ec2:DetachNetworkInterface",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:UnassignPrivateIpAddresses"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:network-interface/*"
            ]
        },
        {
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVolumes",
                "ec2:DescribeVolumesModifications",
                "ec2:DescribeVpcs",
                "eks:DescribeCluster"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource",
                "ecr:DescribeImageScanFindings"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstanceStatus"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ds:CreateComputer",
                "ds:DescribeDirectories"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Action": [
                "waf:*",
                "waf-regional:*",
                "wafv2:*",
                "elasticloadbalancing:SetWebACL",
                "apigateway:SetWebACL",
                "appsync:SetWebACL"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "tag:GetResources"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "k8s-dynamodb-policy" {
  name   = "${local.env}-${local.project}-k8s-dynamodb-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchGetItem",
                "dynamodb:BatchWriteItem",
                "dynamodb:ConditionCheckItem",
                "dynamodb:PutItem",
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:Scan",
                "dynamodb:ListTagsOfResource",
                "dynamodb:Query",
                "dynamodb:UpdateItem"
            ],
            "Resource": "arn:aws:dynamodb:${local.region}:${local.account-id}:table/${local.env}-${local.project}-*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "dynamodb:Scan",
                "dynamodb:Query",
                "dynamodb:DescribeStream",
                "dynamodb:GetRecords"
            ],
            "Resource": [
                "arn:aws:dynamodb:${local.region}:${local.account-id}:table/${local.env}-${local.project}-*/index/*",
                "arn:aws:dynamodb:${local.region}:${local.account-id}:table/${local.env}-${local.project}-*/stream/*"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "dynamodb:ListTables",
                "dynamodb:ListStreams"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "k8s-s3-policy" {
  name   = "${local.env}-${local.project}-k8s-s3-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketObjectLockConfiguration",
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::*/*",
                "arn:aws:s3:::${local.env}-${local.project}-*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        }
    ]
}
EOF
}

# Karpenter Controller policy
# resource "aws_iam_policy" "karpenter_controller_policy" {
#   name = "${local.env}-${local.project}-karpenter_controller_policy"
#   policy = <<EOF
# {
#     "Statement": [
#         {
#             "Action": [
#                 "ssm:GetParameter",
#                 "iam:PassRole",
#                 "ec2:DescribeImages",
#                 "ec2:RunInstances",
#                 "ec2:DescribeSubnets",
#                 "ec2:DescribeSecurityGroups",
#                 "ec2:DescribeLaunchTemplates",
#                 "ec2:DescribeInstances",
#                 "ec2:DescribeInstanceTypes",
#                 "ec2:DescribeInstanceTypeOfferings",
#                 "ec2:DescribeAvailabilityZones",
#                 "ec2:DeleteLaunchTemplate",
#                 "ec2:CreateTags",
#                 "ec2:CreateLaunchTemplate",
#                 "ec2:CreateFleet",
#                 "ec2:DescribeSpotPriceHistory",
#                 "pricing:GetProducts"
#             ],
#             "Effect": "Allow",
#             "Resource": "*",
#             "Sid": "Karpenter"
#         },
#         {
#             "Action": "ec2:TerminateInstances",
#             "Condition": {
#                 "StringLike": {
#                     "ec2:ResourceTag/Name": "*karpenter*"
#                 }
#             },
#             "Effect": "Allow",
#             "Resource": "*",
#             "Sid": "ConditionalEC2Termination"
#         }
#     ],
#     "Version": "2012-10-17"
# }
# EOF
# }

resource "aws_iam_role" "fargate-profile-role" {
  name = "eks-fargate-profile-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate-profile-role.name
}

resource "aws_eks_fargate_profile" "example" {
  cluster_name           = module.eks-cluster.cluster_name
  fargate_profile_name   = "munna-test"
  pod_execution_role_arn = aws_iam_role.fargate-profile-role.arn
  subnet_ids             = ["subnet-033e1d9428f91f483", "subnet-04ebd429464000948"]

  selector {
    namespace = "munna"
    labels = {
        "fargate" = "launch"
      }
  }
}

#test