#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <playbookName> <bucketName> <versionNumber>"
    exit 1
fi

# Assign variables
playbookName="$1"
bucketName="$2"
versionNumber="$3"

# Navigate to deployment directory
cd deployment || exit

# Make scripts executable
chmod +x ./build-s3-dist.sh
chmod +x ./upload-s3-dist.sh

# Execute build script with parameters
./build-s3-dist.sh -b "$playbookName" -v "$versionNumber"

# Synchronize built assets to the specified S3 bucket and version
#aws s3 sync ./global-s3-assets "$bucketName/$versionNumber/"

# Execute upload script for multiple regions
regions=(ap-southeast-2 ap-northeast-1 us-east-1 us-east-2 us-west-1 us-west-2 ap-southeast-1 ap-south-1 eu-west-1 eu-west-2)
#for region in "${regions[@]}"; do
#    ./upload-s3-dist.sh "$region"
#done