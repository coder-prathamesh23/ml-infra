import os
import json
import boto3
import logging
import uuid

logger = logging.getLogger()
logger.setLevel(logging.INFO)

sm = boto3.client("sagemaker")
s3 = boto3.client("s3")

EXECUTION_ROLE_ARN = os.environ.get("SAGEMAKER_EXECUTION_ROLE")
S3_BUCKET = os.environ.get("S3_BUCKET")
ACCURACY_THRESHOLD = float(os.environ.get("ACCURACY_THRESHOLD", "0.80"))
DEFAULT_ENDPOINT_NAME = os.environ.get("DEFAULT_ENDPOINT_NAME", "ml-endpoint")

def lambda_handler(event, context):
    logger.info("Event: %s", json.dumps(event))
    detail = event.get("detail", {})
    model_package_arn = detail.get("ModelPackageArn") or detail.get("ModelPackageName")
    if not model_package_arn:
        logger.error("No ModelPackageArn in event")
        return {"status": "no_model_package_arn"}

    try:
        desc = sm.describe_model_package(ModelPackageName=model_package_arn)
    except Exception as e:
        logger.exception("describe_model_package failed")
        raise

    # Extract metrics (adapt to your pipeline output)
    accuracy = extract_accuracy_from_model_package(desc)
    logger.info("Extracted accuracy: %s", accuracy)

    approved = True if accuracy is None or accuracy >= ACCURACY_THRESHOLD else False
    new_status = "Approved" if approved else "Rejected"

    try:
        sm.update_model_package(
            ModelPackageArn=model_package_arn,
            ModelApprovalStatus=new_status,
            ApprovalDescription=f"Auto-{new_status} by Lambda"
        )
        logger.info("Updated model package %s to %s", model_package_arn, new_status)
    except Exception:
        logger.exception("Failed to update model package status")
        raise

    if not approved:
        return {"status": "rejected", "accuracy": accuracy}

    # Deploy the model package
    model_name = f"model-{uuid.uuid4().hex[:8]}"
    endpoint_cfg = f"{model_name}-cfg"
    endpoint_name = DEFAULT_ENDPOINT_NAME

    try:
        sm.create_model(
            ModelName=model_name,
            PrimaryContainer={"ModelPackageName": model_package_arn},
            ExecutionRoleArn=EXECUTION_ROLE_ARN
        )
        logger.info("Created model %s", model_name)

        sm.create_endpoint_config(
            EndpointConfigName=endpoint_cfg,
            ProductionVariants=[{
                "VariantName": "AllTraffic",
                "ModelName": model_name,
                "InitialInstanceCount": 1,
                "InstanceType": os.environ.get("INFERENCE_INSTANCE_TYPE", "ml.m5.large")
            }]
        )
        logger.info("Created endpoint config %s", endpoint_cfg)

        try:
            sm.create_endpoint(EndpointName=endpoint_name, EndpointConfigName=endpoint_cfg)
            logger.info("Created endpoint %s", endpoint_name)
        except sm.exceptions.ClientError as e:
            if "AlreadyExists" in str(e):
                sm.update_endpoint(EndpointName=endpoint_name, EndpointConfigName=endpoint_cfg)
                logger.info("Updated endpoint %s", endpoint_name)
            else:
                raise
    except Exception:
        logger.exception("Deployment failed")
        raise

    return {"status": "deployed", "model": model_name, "endpoint": endpoint_name}


def extract_accuracy_from_model_package(desc):
    """
    Adapt this to your pipeline's ModelMetrics / metadata.
    If your pipeline stores evaluation JSON at a known S3 path, parse it here.
    Returning None defaults to approve.
    """
    try:
        mm = desc.get("ModelMetrics")
        if not mm:
            return None
        # Custom parse per your pipeline. Keep None if not found.
        return None
    except Exception:
        return None