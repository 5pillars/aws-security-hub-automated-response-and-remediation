cd deployment
chmod +x ./build-s3-dist.sh
./build-s3-dist.sh -b 5pillars-prod-playbooks -c v2.0.1.11
./build-s3-dist.sh -b 5pillars-prod-playbooks -v v2.0.1.11
aws s3 sync ./global-s3-assets s3://5pillars-prod-playbooks-reference/aws-security-hub-automated-response-and-remediation/latest/
aws s3 sync ./global-s3-assets s3://5pillars-prod-playbooks-reference/aws-security-hub-automated-response-and-remediation/v2.0.1.11/ # replace this with correct versio
chmod +x ./upload-s3-dist.sh
./upload-s3-dist.sh ap-southeast-2
./upload-s3-dist.sh ap-northeast-1
./upload-s3-dist.sh us-east-1
./upload-s3-dist.sh us-east-2
./upload-s3-dist.sh us-west-1
./upload-s3-dist.sh us-west-2
./upload-s3-dist.sh ap-southeast-1
./upload-s3-dist.sh ap-south-1
./upload-s3-dist.sh eu-west-1
./upload-s3-dist.sh eu-west-2