# AWS VPC Peering with Terraform

A hands-on AWS networking project that demonstrates how to establish **private communication between two Amazon VPCs using VPC Peering**, with infrastructure provisioned and managed through Terraform.

The project focuses on VPC networking, route table configuration, security group rules, EC2 connectivity, and infrastructure as code.

## Architecture Overview

The architecture consists of two VPCs in the AWS Sydney Region (`ap-southeast-2`), connected through a VPC Peering Connection.

| Component | Primary VPC | Secondary VPC |
|---|---|---|
| VPC CIDR | `10.0.0.0/16` | `10.1.0.0/16` |
| Subnet CIDR | `10.0.1.0/24` | `10.1.1.0/24` |
| EC2 Instance | Amazon Linux 2023 | Amazon Linux 2023 |
| Private IP | `10.0.1.32` | `10.1.1.192` |

**VPC Peering Connection:** `pcx-0713adb9b37cb9a21`

### Architecture Diagram

```text
                 AWS Cloud
                     |
        +------------+------------+
        |                         |
  +-----v------+            +-----v------+
  | Primary VPC|            |Secondary VPC|
  |10.0.0.0/16 |            |10.1.0.0/16  |
  |            |            |             |
  |  Public    |            |  Public     |
  |  Subnet    |            |  Subnet     |
  |            |            |             |
  |  EC2       |            |  EC2        |
  |10.0.1.32   |            |10.1.1.192   |
  +-----+------+            +------+------+
        |                          |
        +------------+-------------+
                     |
              VPC Peering
               Connection
                     |
          Private IP Communication
```

## Technologies Used

- **Amazon Web Services (AWS)**
  - Amazon VPC
  - VPC Peering
  - EC2
  - Internet Gateway
  - Route Tables
  - Security Groups
- **Terraform** – Infrastructure as Code
- **AWS CLI** – AWS resource and credential management
- **Git & GitHub** – Version control and project documentation

## Project Structure

```text
day-15-vpc-pearing/
│
├── main.tf
├── provider.tf
├── variable.tf
├── terraform.tfvars
├── networking.tf
├── security.tf
├── compute.tf
├── output.tf
├── .gitignore
├── .terraform.lock.hcl
└── README.md
```

| File | Purpose |
|---|---|
| `provider.tf` | AWS provider configuration |
| `main.tf` | Main infrastructure and VPC peering resources |
| `variable.tf` | Input variable declarations |
| `terraform.tfvars` | Environment-specific variable values |
| `networking.tf` | VPCs, subnets, internet gateways, route tables and routes |
| `security.tf` | Security group configuration |
| `compute.tf` | EC2 instance configuration |
| `output.tf` | Terraform output values |
| `.gitignore` | Excludes local state, credentials and other unnecessary files |
| `.terraform.lock.hcl` | Locks provider dependency versions |

## Key Implementation Details

### 1. VPC Creation

Created two separate VPCs with non-overlapping CIDR ranges:

- Primary VPC: `10.0.0.0/16`
- Secondary VPC: `10.1.0.0/16`

Using non-overlapping CIDR blocks allows both VPCs to communicate through VPC Peering.

### 2. VPC Peering Connection

Created a VPC Peering Connection between the primary and secondary VPCs.

The peering connection provides private network connectivity between the two VPCs without requiring traffic to traverse the public internet.

### 3. Route Table Configuration

Configured routes in both VPCs to direct traffic destined for the opposite VPC through the peering connection.

| Route Table | Destination | Target |
|---|---|---|
| Primary VPC | `10.1.0.0/16` | VPC Peering Connection |
| Secondary VPC | `10.0.0.0/16` | VPC Peering Connection |

Both sides require appropriate routes for bidirectional communication.

### 4. Security Group Configuration

Configured security groups to control network traffic between the EC2 instances.

The rules include:

- SSH access on TCP port 22 from the configured administrator CIDR.
- ICMP traffic permitted from the opposite VPC CIDR for connectivity testing.
- HTTP access on TCP port 80 as configured in the lab.
- Outbound traffic rules for communication.

**Security consideration:** For a production environment, restrict HTTP access to the required peer CIDR rather than allowing `0.0.0.0/0`, and restrict SSH access to trusted administrator IP addresses.

### 5. EC2 Deployment

Deployed Amazon Linux 2023 EC2 instances in both VPCs.

| Instance | Private IP |
|---|---|
| Primary EC2 | `10.0.1.32` |
| Secondary EC2 | `10.1.1.192` |

SSH access was tested from the local machine using the corresponding EC2 key pairs.

## Deployment Guide

### Prerequisites

Ensure the following tools are installed:

- AWS CLI
- Terraform
- Git
- SSH client

Configure AWS credentials using an appropriate AWS CLI profile.

Example:

```bash
aws configure --profile terraform-user
```

Verify the configured identity:

```bash
aws sts get-caller-identity --profile terraform-user
```

### Step 1: Clone the Repository

```bash
git clone https://github.com/safaYa12/aws-vpc-peering-terraform.git
```

Navigate into the project:

```bash
cd aws-vpc-peering-terraform
```

### Step 2: Configure Variables

Review the input variables and configure the required values in `terraform.tfvars`.

Do not commit personal configuration or credentials to a public repository.

### Step 3: Initialize Terraform

```bash
terraform init
```

This initializes the working directory and downloads the required Terraform providers.

### Step 4: Validate Configuration

```bash
terraform validate
```

### Step 5: Review the Execution Plan

```bash
terraform plan
```

Review the proposed infrastructure changes before applying them.

### Step 6: Deploy Infrastructure

```bash
terraform apply
```

Review the execution plan and confirm the deployment when prompted.

### Step 7: View Outputs

```bash
terraform output
```

Use the returned instance addresses and resource information for connectivity testing.

## Connectivity Testing

The main objective was to verify private communication between EC2 instances across the two VPCs.

### Primary VPC to Secondary VPC

From the Primary EC2 instance:

```bash
ping 10.1.1.192
```

**Result:** Successful ICMP communication with the Secondary EC2 instance.

### Secondary VPC to Primary VPC

From the Secondary EC2 instance:

```bash
ping 10.0.1.32
```

**Result:** Successful ICMP communication with the Primary EC2 instance after correcting the ICMP ingress rule in the Primary security group.

### Validation Summary

| Test | Result |
|---|---|
| SSH access to Primary EC2 | Successful |
| SSH access to Secondary EC2 | Successful |
| Primary to Secondary private IP connectivity | Successful |
| Secondary to Primary private IP connectivity | Successful |
| Bidirectional ICMP communication | Verified |

These tests confirmed that the VPC Peering Connection, route tables, and security group rules were configured to support bidirectional private communication.

## Important AWS Networking Concepts Learned

- VPC Peering enables private communication between two VPCs.
- VPC Peering is non-transitive: a peered VPC cannot automatically use another VPC's peering connection to reach a third VPC.
- CIDR ranges must not overlap for VPC Peering.
- Both VPCs need appropriate routes for bidirectional connectivity.
- Security groups must allow the required traffic.
- A successful peering connection alone does not guarantee connectivity; routing and security configurations must also be correct.
- Terraform enables repeatable and version-controlled infrastructure provisioning.

## Security and Cost Considerations

- Avoid exposing SSH to the entire internet.
- Restrict application traffic to trusted CIDR ranges.
- Never commit AWS access keys, private keys, Terraform state files, or other secrets.
- Review Terraform plans before applying changes.
- VPC Peering data transfer and EC2 usage may incur AWS charges.
- Delete unused resources after completing the lab.

## Cleanup

To remove the Terraform-managed infrastructure:

```bash
terraform destroy
```

Review the proposed destruction plan carefully and confirm only when you are ready to remove the resources.

## Future Improvements

Potential extensions to this project include:

- Implementing AWS Transit Gateway for multi-VPC connectivity.
- Introducing network segmentation using dedicated Transit Gateway route tables.
- Integrating VPC Flow Logs for network traffic visibility.
- Centralizing network monitoring and security analysis.
- Implementing more restrictive security group rules.

## Author

**Muhammed Safayath T.**

AWS | Cloud Security | Cybersecurity

GitHub: [@safaYa12](https://github.com/safaYa12)

---

*This project was built as a hands-on exercise to understand AWS networking fundamentals and implement VPC connectivity using Terraform.*
