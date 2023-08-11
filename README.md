# Basic Website Hosting With Terraform 
AWS website hosting from an S3 bucket made available through Terraform


MineSweeper site example:

Setup:

1. This project uses an S3 bucket to maintain state. This will need to be configured in the providers.tf file. You will at least need to change the bucket name, if not the key (state file name) aswell. 

2. The actions.yml file has a "PROJECT_NAME" value and the terraform.tfvars file has a "site_name" value. These control the name of the infrastructure created, and changing them can create a competing site. 


Deployment:

> terraform init

> terraform plan

> terraform apply

Update site assets example to min sweeper bucket:
> aws s3 cp Website s3://mine-sweeper-site-assets/ --recursive
