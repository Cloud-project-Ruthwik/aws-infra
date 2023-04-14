Networks and Cloud Computing Assignments
Made using Terraform 
The following code installs VPC, EC2, RDS, S3 in AWS
The following variables can be specified : Region, VPC CIDR Block, VPC Name, profile, public subnet count, private subnet count, public subnet CIDR Blocks and private subnet CIDR Blocks and Many more

The number of Public Subnets and Private Subnets can be specified too

Use:

export AWS_REGION=us-west-2
terraform apply

To get availability zones values.

In order to rewrite the default values use the command
terraform apply -var "region=us-west-2"

terraform apply -var "region=us-west-2" -var "vpc_cidr_block=10.1.0.0/16"

To Access the profiles set up use the command
terraform apply -var-file="dev.tfvars"

To destroy the resources created in other regions use the command

terraform destroy -var 'region=us-east-1'

To import the certificates follow the below command:

aws acm import-certificate --profile demo --region us-east-1 --certificate fileb://prod_ruthwikbg_me.crt --private-key fileb://private.key --certificate-chain fileb://prod_ruthwikbg_me.ca-bundle

Replace  prod.ruthwikbg.me.crt, prod.ruthwikbg.me.ca-bundle and private.key with the appropriate file paths respectively.
