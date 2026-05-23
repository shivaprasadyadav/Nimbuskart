import boto3

ec2 = boto3.client(
    "ec2",
    endpoint_url="http://localhost:4566",
    region_name="us-east-1",
    aws_access_key_id="test",
    aws_secret_access_key="test"
)

volumes = ec2.describe_volumes()

for v in volumes["Volumes"]:
    if len(v["Attachments"]) == 0:
        print(f"Orphan Volume Found: {v['VolumeId']}")
