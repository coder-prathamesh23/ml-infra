SageMaker

sagemaker:CreateDomain
sagemaker:UpdateDomain
sagemaker:DeleteDomain
sagemaker:DescribeDomain
sagemaker:ListDomains
sagemaker:CreateUserProfile
sagemaker:UpdateUserProfile
sagemaker:DeleteUserProfile
sagemaker:DescribeUserProfile
sagemaker:ListUserProfiles
sagemaker:CreateStudioLifecycleConfig
sagemaker:DeleteStudioLifecycleConfig
sagemaker:DescribeStudioLifecycleConfig
sagemaker:ListStudioLifecycleConfigs
sagemaker:CreateModelPackageGroup
sagemaker:DescribeModelPackageGroup
sagemaker:ListModelPackageGroups
sagemaker:PutModelPackageGroupPolicy
sagemaker:DeleteModelPackageGroupPolicy
sagemaker:DescribeModelPackage
sagemaker:ListModelPackages
sagemaker:CreatePipeline
sagemaker:UpdatePipeline
sagemaker:DeletePipeline
sagemaker:StartPipelineExecution
sagemaker:StopPipelineExecution
sagemaker:DescribePipeline
sagemaker:DescribePipelineExecution
sagemaker:ListPipelines
sagemaker:ListPipelineExecutions
sagemaker:CreateModel
sagemaker:DeleteModel
sagemaker:CreateEndpointConfig
sagemaker:DeleteEndpointConfig
sagemaker:CreateEndpoint
sagemaker:UpdateEndpoint
sagemaker:DeleteEndpoint
sagemaker:DescribeEndpoint
sagemaker:DescribeEndpointConfig
sagemaker:TagResource
sagemaker:UntagResource

⸻

Lambda (Terraform deployer – function management)

lambda:CreateFunction
lambda:UpdateFunctionCode
lambda:UpdateFunctionConfiguration
lambda:PublishVersion
lambda:CreateAlias
lambda:UpdateAlias
lambda:DeleteFunction
lambda:DeleteAlias
lambda:AddPermission
lambda:RemovePermission
lambda:GetFunction
lambda:ListFunctions
lambda:TagResource
lambda:UntagResource

⸻

Lambda (runtime execution role)

sagemaker:DescribeModelPackage
sagemaker:UpdateModelPackage
sagemaker:CreateModel
sagemaker:CreateEndpointConfig
sagemaker:CreateEndpoint
sagemaker:UpdateEndpoint
sagemaker:DescribeEndpoint
sagemaker:DescribeEndpointConfig
iam:PassRole
s3:GetObject
logs:CreateLogGroup
logs:CreateLogStream
logs:PutLogEvents
kms:Decrypt
kms:DescribeKey

⸻

EventBridge (rule + target setup)

events:PutRule
events:PutTargets
events:RemoveTargets
events:EnableRule
events:DisableRule
events:DeleteRule
events:DescribeRule
events:ListTargetsByRule
events:TagResource
events:UntagResource

⸻

CloudWatch Logs

logs:CreateLogGroup
logs:PutRetentionPolicy
logs:DeleteLogGroup
logs:CreateLogStream
logs:PutLogEvents
logs:TagLogGroup

⸻

EC2 / VPC Networking

ec2:CreateSecurityGroup
ec2:DeleteSecurityGroup
ec2:AuthorizeSecurityGroupIngress
ec2:AuthorizeSecurityGroupEgress
ec2:RevokeSecurityGroupIngress
ec2:RevokeSecurityGroupEgress
ec2:CreateTags
ec2:DeleteTags
ec2:DescribeVpcs
ec2:DescribeSubnets
ec2:DescribeSecurityGroups

⸻

S3 (Artifacts / Metrics / Pipeline data)

s3:ListBucket
s3:GetBucketLocation
s3:GetObject
s3:PutObject
s3:DeleteObject
s3:AbortMultipartUpload
s3:ListBucketMultipartUploads
s3:ListBucketVersions

⸻

IAM (roles & policies for Studio + Lambda + Pipelines)

iam:CreateRole
iam:UpdateAssumeRolePolicy
iam:PutRolePolicy
iam:AttachRolePolicy
iam:DetachRolePolicy
iam:DeleteRolePolicy
iam:DeleteRole
iam:GetRole
iam:TagRole
iam:CreateServiceLinkedRole
iam:DeleteServiceLinkedRole
iam:GetServiceLinkedRoleDeletionStatus
iam:PassRole

⸻

ECR (used for custom training / inference images)

ecr:CreateRepository
ecr:DeleteRepository
ecr:SetRepositoryPolicy
ecr:GetRepositoryPolicy
ecr:PutLifecyclePolicy
ecr:DescribeRepositories
ecr:DescribeImages
ecr:TagResource
ecr:UntagResource

⸻

ECR (Repo Policy – resource-based)

ecr:BatchCheckLayerAvailability
ecr:GetDownloadUrlForLayer
ecr:BatchGetImage

⸻

KMS (if S3 or logs use CMK)

kms:DescribeKey
kms:ListAliases
kms:ListKeys
kms:CreateAlias
kms:UpdateAlias
kms:Encrypt
kms:Decrypt
kms:GenerateDataKey*

⸻

CloudWatch (alarms / metrics optional)

cloudwatch:PutMetricAlarm
cloudwatch:DeleteAlarms
cloudwatch:DescribeAlarms
cloudwatch:PutMetricData
