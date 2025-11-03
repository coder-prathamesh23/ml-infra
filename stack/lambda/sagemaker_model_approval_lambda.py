import os
import json
import boto3
import logging
import uuid
from botocore.exceptions import ClientError

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Global SageMaker client (will be initialized lazily or by the Lambda runtime)
sm = None

def get_sagemaker_client():
    """Initializes and returns the SageMaker Boto3 client."""
    global sm
    if sm is None:
        # In a real Lambda, the region is automatically picked up from the environment
        region = os.environ.get("AWS_REGION")
        sm = boto3.client("sagemaker", region_name=region)
    return sm

# Environment variables (fail fast if SAGEMAKER_EXECUTION_ROLE is missing)
try:
    EXECUTION_ROLE_ARN = os.environ["SAGEMAKER_EXECUTION_ROLE"]
except KeyError:
    logger.error("SAGEMAKER_EXECUTION_ROLE environment variable is not set.")
    raise

ACCURACY_THRESHOLD = float(os.environ.get("ACCURACY_THRESHOLD", "0.80"))
DEFAULT_ENDPOINT_NAME = os.environ.get("DEFAULT_ENDPOINT_NAME", "ml-endpoint")
INFERENCE_INSTANCE_TYPE = os.environ.get("INFERENCE_INSTANCE_TYPE", "ml.m5.large")


def lambda_handler(event, context):
    logger.info("Event: %s", json.dumps(event))
    detail = event.get("detail", {}) or {}
    
    # The event detail can contain ModelPackageArn or ModelPackageName
    model_package_arn = detail.get("ModelPackageArn") or detail.get("ModelPackageName")
    if not model_package_arn:
        logger.error("No ModelPackageArn/ModelPackageName in event.detail")
        return {"status": "no_model_package_arn"}

    sm_client = get_sagemaker_client()

    # 1. Describe Model Package
    try:
        desc = sm_client.describe_model_package(ModelPackageName=model_package_arn)
    except Exception:
        logger.exception("describe_model_package failed")
        raise

    # 2. Extract and evaluate metrics
    accuracy = extract_accuracy_from_model_package(desc)
    logger.info("Extracted accuracy: %s", accuracy)

    approved = True if accuracy is None or accuracy >= ACCURACY_THRESHOLD else False
    new_status = "Approved" if approved else "Rejected"

    # 3. Update Model Package Status
    try:
        sm_client.update_model_package(
            ModelPackageArn=model_package_arn,
            ModelApprovalStatus=new_status,
            ApprovalDescription=f"Auto-{new_status} by Lambda (Accuracy: {accuracy})"
        )
        logger.info("Updated model package %s to %s", model_package_arn, new_status)
    except Exception:
        logger.exception("Failed to update model package status")
        raise

    if not approved:
        return {"status": "rejected", "accuracy": accuracy}

    # 4. Deploy the approved model package
    model_name = f"model-{uuid.uuid4().hex[:8]}"
    endpoint_cfg = f"{model_name}-cfg"
    endpoint_name = DEFAULT_ENDPOINT_NAME

    try:
        # Create Model
        sm_client.create_model(
            ModelName=model_name,
            PrimaryContainer={"ModelPackageName": model_package_arn},
            ExecutionRoleArn=EXECUTION_ROLE_ARN
        )
        logger.info("Created model %s", model_name)

        # Create Endpoint Config
        sm_client.create_endpoint_config(
            EndpointConfigName=endpoint_cfg,
            ProductionVariants=[{
                "VariantName": "AllTraffic",
                "ModelName": model_name,
                "InitialInstanceCount": 1,
                "InstanceType": INFERENCE_INSTANCE_TYPE,
                "InitialVariantWeight": 1.0
            }]
        )
        logger.info("Created endpoint config %s", endpoint_cfg)

        # Idempotent upsert: update if endpoint exists, else create
        if endpoint_exists(endpoint_name):
            sm_client.update_endpoint(EndpointName=endpoint_name, EndpointConfigName=endpoint_cfg)
            logger.info("Updated endpoint %s", endpoint_name)
        else:
            sm_client.create_endpoint(EndpointName=endpoint_name, EndpointConfigName=endpoint_cfg)
            logger.info("Created endpoint %s", endpoint_name)

    except ClientError as e:
        logger.exception("Deployment failed with ClientError")
        raise
    except Exception:
        logger.exception("Deployment failed")
        raise

    return {"status": "deployed", "model": model_name, "endpoint": endpoint_name}


def endpoint_exists(name: str) -> bool:
    """Checks if a SageMaker endpoint with the given name exists."""
    sm_client = get_sagemaker_client()
    try:
        sm_client.describe_endpoint(EndpointName=name)
        return True
    except ClientError as e:
        # ResourceNotFound is the expected error when an endpoint does not exist
        if e.response.get("Error", {}).get("Code") in ("ValidationException", "ResourceNotFound", "EndpointNotFound"):
            return False
        raise


def extract_accuracy_from_model_package(desc):
    """
    Extracts the accuracy metric from the Model Package description.
    This implementation assumes the accuracy is stored in CustomerMetadataProperties.
    """
    try:
        # Example: read a numeric accuracy stored in customer metadata
        props = desc.get("CustomerMetadataProperties") or {}
        if "accuracy" in props:
            return float(props["accuracy"])

        # Add logic here to parse metrics from S3 if needed (e.g., from ModelMetrics)

        return None
    except Exception:
        logger.exception("Failed to parse accuracy from model package description")
        return None
