# Top-level
app_network_access_type       = "VpcOnly"
app_security_group_management = null
auth_mode                     = "IAM"

# Change this for the clone name
domain_name                   = "development-clone"

kms_key_id        = null
subnet_ids        = [
  "subnet-057c9eac920a4fda8c",
  "subnet-0dda07a5f6c26404a",
  "subnet-0eb44c48bdca9b896",
]
tag_propagation   = "ENABLED"

tags = {
  projectname = "sagemakerlab"
  workorder   = "143808641"
}

vpc_id = "vpc-03c89e5f948384858"

# default_space_settings
default_space_execution_role                = "arn:aws:iam::324644393892:role/SageMaker-ExecutionRole-Privileged"
default_space_security_groups               = ["sg-0b1d6dc461c2945d7"]
default_space_default_volume_size = 50
default_space_maximum_volume_size = 200

# default_user_settings
default_user_auto_mount_home_efs      = null
default_user_default_landing_uri      = "studio:"
default_user_execution_role           = "arn:aws:iam::324644393892:role/SageMaker-ExecutionRole-Privileged"
default_user_security_groups          = ["sg-0b1d6dc461c2945d7"]
default_user_studio_web_portal_status = "ENABLED"

canvas_direct_deploy_status = "ENABLED"

generative_ai_bedrock_role_arn = "arn:aws:iam::324644393892:role/service-role/AmazonSagemakerCanvasBedrockRole-20240610T121385"
generative_ai_status           = "ENABLED"

kendra_status = "ENABLED"

model_register_cross_account_role_arn = null
model_register_status                 = "ENABLED"

forecast_role_arn = "arn:aws:iam::324644393892:role/service-role/AmazonSagemakerCanvasForecastRole-20240610T121386"
forecast_status   = "ENABLED"

workspace_s3_artifact_path = "s3://sagemaker-us-west-2-324644393892"
workspace_s3_kms_key_id    = null

jupyter_lifecycle_config_arns = []
jupyter_instance_type         = "system"
jupyter_lifecycle_config_arn  = null
jupyter_image_arn             = "arn:aws:sagemaker:us-west-2:236514542706:image/jupyter-server-3"
jupyter_image_version_alias   = null
jupyter_image_version_arn     = null

sharing_notebook_output_option = "Allowed"
sharing_s3_kms_key_id          = null
sharing_s3_output_path         = "s3://sagemaker-studio-7nuh6jae492/sharing"

default_user_space_default_volume_size = 50
default_user_space_maximum_volume_size = 200

domain_execution_role_identity_config = null
domain_security_group_ids             = ["sg-0b1d6dc461c2945d7"]