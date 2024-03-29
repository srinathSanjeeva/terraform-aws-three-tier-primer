# Terraform Folder Instructions

This README provides instructions on how to run commands in this Terraform folder and also brief overview about the architecture of the resources to be deployed using these Terraform script.

## Prerequisites

- Terraform installed on your machine
- Properly configured AWS credentials if you're using AWS as a provider

## Steps to Run Commands

1. Navigate to the live folder in your terminal. You can use the command `cd path_to_your_folder/live`.

2. Initialize your Terraform workspace, which will download the provider plugins. Use the command `terraform init`.

3. Create a plan and save it to the local file `tfplan`. You can use the command `terraform plan -out=tfplan`.

4. Apply the plan stored in the `tfplan` file. Use the command `terraform apply "tfplan"`.

Please replace `path_to_your_folder` with the actual path to your Terraform folder.

## Troubleshooting

If you encounter any issues, please check the following:

- Ensure you have the correct permissions set in your AWS credentials.
- Make sure your Terraform files don't have any syntax errors. You can check this by running `terraform validate`.

## Architecture Overview

The architecture of this application consists of four main components:

1. **VPC (Virtual Private Cloud)**: The network layer where all other resources are deployed.

2. **RDS (Relational Database Service) with MySQL**: The database layer, responsible for storing and retrieving the application's data.

3. **Backend**: The application layer, hosted within the VPC. It communicates with the RDS database to perform query operations.

4. **Frontend Application**: The presentation layer, which communicates with the backend to fetch data and display it to the users.

The frontend sends requests to the backend, which in turn queries the RDS database. The results are then sent back up the chain to be displayed to the user.

## Accessing the Application

Once the application is deployed, you can access it by entering the load balancer's public ARN followed by `/api/data` into your web browser. For example:


Please replace `your-load-balancer-arn` with the actual ARN of your load balancer.

This will display the sample data that is hosted inside the database. The frontend application communicates with the backend service to fetch this data and display it to you.

## Sample Response

Here is a sample response when you access the `/api/data` endpoint:

```json
[
  {
    "id": 1,
    "name": "Product1",
    "price": 19.99
  },
  {
    "id": 2,
    "name": "Product2",
    "price": 29.99
  },
  {
    "id": 3,
    "name": "Product3",
    "price": 39.99
  },
  {
    "id": 4,
    "name": "Product1",
    "price": 19.99
  },
  {
    "id": 5,
    "name": "Product2",
    "price": 29.99
  },
  {
    "id": 6,
    "name": "Product3",
    "price": 39.99
  }
]
```

## Contributing

If you have any improvements or issues to report, please open an issue or submit a pull request.

