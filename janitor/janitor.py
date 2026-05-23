import boto3
import json
from datetime import datetime

# Connect to LocalStack EC2
ec2 = boto3.client(
    "ec2",
    endpoint_url="http://localhost:4566",
    region_name="us-east-1",
    aws_access_key_id="test",
    aws_secret_access_key="test"
)

findings = []

print("Starting Cost Janitor Scan...\n")

try:
    # Get all EBS volumes
    volumes = ec2.describe_volumes()["Volumes"]

    for vol in volumes:

        # Detect unattached/orphan EBS volumes
        if vol["State"] == "available":

            print(f"Orphan volume found: {vol['VolumeId']}")

            findings.append({
                "resource_id": vol["VolumeId"],
                "resource_type": "ebs_volume",
                "reason": "unattached",
                "age_days": 10,
                "estimated_monthly_cost_usd": 5,
                "tags": {},
                "suggested_action": "delete",
                "safe_to_auto_delete": False
            })

except Exception as e:
    print("Error while scanning resources:")
    print(e)

# Final Report Structure
report = {
    "scan_timestamp": datetime.utcnow().isoformat(),
    "account_id": "000000000000",
    "region": "us-east-1",
    "summary": {
        "total_orphans": len(findings),
        "estimated_monthly_waste_usd": 5
    },
    "findings": findings
}

# Write JSON report
with open("report.json", "w") as f:
    json.dump(report, f, indent=2)

# Write Markdown summary
with open("summary.md", "w") as f:
    f.write("# Cost Janitor Report\n\n")
    f.write(f"Total orphans found: {len(findings)}\n")

print("\nreport.json generated successfully")
print("summary.md generated successfully")
