# Navigate to the desired directory using
cd aws-stacks/
# After this choose which stack you want to run terraform for example :
cd rds-mssql/

# Create and select the "dev" workspace
terraform workspace new dev
terraform workspace select dev

# Apply the configuration for the "dev" workspace
terraform init
terraform apply

# Create and select the "test" workspace
terraform workspace new test
terraform workspace select test

# Apply the configuration for the "test" workspace
terraform init
terraform apply

# Create and select the "prod" workspace
terraform workspace new prod
terraform workspace select prod

# Apply the configuration for the "prod" workspace
terraform init
terraform apply