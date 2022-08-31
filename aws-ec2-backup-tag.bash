#!/bin/bash

sudo aws ec2 describe-instances --filters --query 'Reservations[].Instances[?!not_null(Tags[?Key == `backup`].Value)] | []' --region 'region-name' --output json > response.json
nodes=$(cat response.json |grep InstanceId| awk -F "\"" '{print $4}' | sort | uniq | awk NF)

echo $nodes

for HOST in $nodes
do
        echo "run"
       sudo aws ec2 create-tags --resources $HOST  --region 'region-name' --tags "Key=backup,Value=yes"
done
echo "successful"
