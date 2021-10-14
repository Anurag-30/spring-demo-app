# Creating EKS cluster

Create an IAM user with necessary privileges and export Access_key and Secret_key as environment variables.

1. Run `terraform init` to install required plugins 
2. Run `terraform plan` to see the list of resources that are about to get created
3. Run `terraform apply --auto-approve` to create those resources

If you observe carefully a file with the name `terraform.tfstate` is created since we are not using any backend it's advised to be careful not to delete the file as it contains the state of the infra created.