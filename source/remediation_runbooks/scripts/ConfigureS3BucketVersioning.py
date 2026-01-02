# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

import boto3
from botocore.config import Config

BOTO_CONFIG = Config(retries={"mode": "standard", "max_attempts": 10})

def connect_to_s3():
    return boto3.client("s3", config=BOTO_CONFIG)

def lambda_handler(event, _):
    bucket_name = event["BucketName"]
    versioning_state = event.get("VersioningState", "Enabled")

    if versioning_state not in ["Enabled", "Suspended"]:
        raise ValueError(
            f"Invalid VersioningState '{versioning_state}'. Must be Enabled or Suspended."
        )

    s3 = connect_to_s3()

    # Apply bucket versioning
    s3.put_bucket_versioning(
        Bucket=bucket_name,
        VersioningConfiguration={
            "Status": versioning_state
        }
    )

    # Read back the configuration to verify
    versioning = s3.get_bucket_versioning(Bucket=bucket_name)
    applied_state = versioning.get("Status", "Disabled")

    if applied_state == versioning_state:
        return {
            "bucket": bucket_name,
            "versioning_state": applied_state,
            "status": "Success",
            "message": f"S3 bucket versioning set to {applied_state}"
        }

    raise RuntimeError(
        f"Failed to set bucket versioning. Expected {versioning_state}, got {applied_state}"
    )
