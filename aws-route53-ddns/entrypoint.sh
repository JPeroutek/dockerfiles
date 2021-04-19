#! /bin/bash

# Unfortunately, due to issues with environment variables, we need to store the AWS secrets in the config file
mkdir -p ~/.aws/
cat > ~/.aws/config << EOF
[default]
aws_access_key_id=$AWS_ACCESS_KEY_ID
aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
region=$AWS_REGION
EOF

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_REGION

IP=$(curl -s https://api.ipify.org/)

if [[ ! $IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
  exit 1
fi

aws route53 list-resource-record-sets --hosted-zone-id $ROUTE53_HOSTED_ZONE_ID | \
jq -r '.ResourceRecordSets[] | select (.Name == "'"$ROUTE53_DOMAIN"'") | select (.Type == "'"$ROUTE53_TYPE"'") | .ResourceRecords[0].Value' > /tmp/current_route53_address

if grep -Fxq "$IP" /tmp/current_route53_address; then
   echo "IP Has Not Changed, Exiting"
   exit 1
fi

echo "Setting new address: $IP"

cat > /tmp/route53_changes.json << EOF
    {
      "Comment":"Updated From aws_route53_ddns Docker Image",
      "Changes":[
        {
          "Action":"UPSERT",
          "ResourceRecordSet":{
            "ResourceRecords":[
              {
                "Value":"$IP"
              }
            ],
            "Name":"$ROUTE53_DOMAIN",
            "Type":"$ROUTE53_TYPE",
            "TTL":$ROUTE53_TTL
          }
        }
      ]
    }
EOF

aws route53 change-resource-record-sets --hosted-zone-id $ROUTE53_HOSTED_ZONE_ID --change-batch file:///tmp/route53_changes.json