locals {
  # Define your VPC name dynamically based on the workspace
  vpc_name = "${terraform.workspace}-my-vpc"
  create_public_subnets = terraform.workspace == "prod"
  public_subnets  = terraform.workspace == "prod" ? [for i in range(3) : cidrsubnet(var.cidr, 4, i)] : []
  private_subnets = [for i in range(3) : cidrsubnet(var.cidr, 4, i + 3)]

  # Define your tags, merging dynamic values based on the workspace
  tags = {
    Project     = "aws-stacks/vpc",
    Owner       = "Rishabh Mishra",
    Environment = terraform.workspace
  }
}