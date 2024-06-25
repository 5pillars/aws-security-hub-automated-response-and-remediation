$playbookName = $1
$bucketName = $2
$versionNumber = $3
cd deployment
chmod +x ./build-s3-dist.sh
./build-s3-dist.sh -b $playbookName -c $versionNumber
./build-s3-dist.sh -b $playbookName -v $versionNumber
#aws s3 sync ./global-s3-assets $bucketName/latest/
aws s3 sync ./global-s3-assets $bucketName/$versionNumber/ # replace this with correct version
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