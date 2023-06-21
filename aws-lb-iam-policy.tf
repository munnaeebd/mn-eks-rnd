resource "aws_iam_policy" "aws_load_balancer_controller" {
  policy = file("./aws-lb-iam-policy.json")
  name   = "AWSLoadBalancerControlleri-munna"
}
