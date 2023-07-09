# mn-eks-rnd
mn-eks-rnd

## Login to the IAM console: https://us-east-1.console.aws.amazon.com/iamv2/home?region=ap-southeast-1#/identity_providers
```
Identity Providers --> Add provider--> OpenID Connect (copy the URL from EKS-console) --> Audience (sts.amazonaws.com)--> Create.

IAM-->Roles-->Create Role-->Web identity--> Select the above created identity provider--> select required policy--> Next--> \
Create Role--> edit the newly  created role-->go to the "Trust relationships" tab--> Edit-->

        "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:sub": "system:serviceaccount:default:my-service-account",
                    "oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:aud": "sts.amazonaws.com"

-->Save.

Then Create service account and required pod with the new service account. This pod should access the AWS services allowed in the IAM policies. 
```


(C) 2023
