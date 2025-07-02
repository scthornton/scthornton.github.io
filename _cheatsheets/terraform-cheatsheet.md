---
layout: cheatsheet
title: "Terraform Cheatsheet"
description: "Terraform Notes"
date: 2025-01-25
categories: [tools, productivity]  
tags: [IaC, TF, terraform, automation]
---


# Terraform NOtes

## Table of Contents
1. [Basic Concepts](#basic-concepts)
2. [Configuration Syntax](#configuration-syntax)
3. [Providers](#providers)
4. [Resources](#resources)
5. [Variables](#variables)
6. [Outputs](#outputs)
7. [Data Sources](#data-sources)
8. [Locals](#locals)
9. [Modules](#modules)
10. [State Management](#state-management)
11. [Expressions and Functions](#expressions-and-functions)
12. [Conditionals and Loops](#conditionals-and-loops)
13. [Provisioners](#provisioners)
14. [Workspaces](#workspaces)
15. [Import and Move](#import-and-move)
16. [Terraform Commands](#terraform-commands)
17. [Best Practices](#best-practices)
18. [Common Patterns](#common-patterns)
19. [Debugging and Troubleshooting](#debugging-and-troubleshooting)
20. [Backend Configuration](#backend-configuration)

## Basic Concepts

### What is Terraform?
Terraform is an Infrastructure as Code (IaC) tool that allows you to define and provision infrastructure using a declarative configuration language.

### Key Principles
- **Declarative**: You describe the desired state, Terraform figures out how to achieve it
- **Idempotent**: Running the same configuration multiple times produces the same result
- **State-based**: Terraform tracks infrastructure state to determine changes
- **Provider-agnostic**: Works with multiple cloud providers and services

### File Structure
```
project/
├── main.tf           # Main configuration
├── variables.tf      # Variable declarations
├── outputs.tf        # Output declarations
├── terraform.tfvars  # Variable values
├── versions.tf       # Provider version constraints
└── modules/          # Custom modules
    └── vpc/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Configuration Syntax

### HCL (HashiCorp Configuration Language) Basics
```hcl
# Single line comment

/*
Multi-line
comment
*/

# Basic syntax
resource "provider_type" "name" {
  argument = "value"
  
  nested_block {
    nested_argument = "nested_value"
  }
}

# Terraform block
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

## Providers

### Provider Configuration
```hcl
# Basic provider
provider "aws" {
  region = "us-west-2"
}

# Multiple provider instances (aliasing)
provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu_west"
  region = "eu-west-1"
}

# Using aliased provider
resource "aws_instance" "example" {
  provider = aws.us_east
  # ... other configuration
}

# Provider with authentication
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  
  # Or use shared credentials file
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "myprofile"
}

# Environment variables (recommended)
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
```

### Common Providers
```hcl
# AWS
provider "aws" {
  region = "us-west-2"
}

# Azure
provider "azurerm" {
  features {}
  subscription_id = "..."
  tenant_id       = "..."
}

# Google Cloud
provider "google" {
  project = "my-project-id"
  region  = "us-central1"
}

# Kubernetes
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Docker
provider "docker" {
  host = "tcp://localhost:2376/"
}
```

## Resources

### Basic Resource Syntax
```hcl
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name        = "WebServer"
    Environment = "Production"
  }
}

# Resource with count
resource "aws_instance" "web_server" {
  count         = 3
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "WebServer-${count.index}"
  }
}

# Resource with for_each
resource "aws_instance" "web_server" {
  for_each = toset(["web1", "web2", "web3"])
  
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = each.key
  }
}
```

### Resource Dependencies
```hcl
# Implicit dependency
resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id  # Implicit dependency
}

# Explicit dependency
resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  depends_on = [
    aws_security_group.allow_ssh,
    aws_iam_role.instance_role
  ]
}
```

### Resource Lifecycle
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes        = [tags]
    
    # Custom condition
    precondition {
      condition     = data.aws_ami.example.architecture == "x86_64"
      error_message = "The selected AMI must be x86_64 architecture."
    }
  }
}
```

## Variables

### Variable Declaration
```hcl
# Basic variable
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

# Variable types
variable "string_var" {
  type = string
}

variable "number_var" {
  type = number
}

variable "bool_var" {
  type = bool
}

variable "list_var" {
  type = list(string)
}

variable "set_var" {
  type = set(string)
}

variable "map_var" {
  type = map(string)
}

variable "object_var" {
  type = object({
    name = string
    age  = number
  })
}

variable "tuple_var" {
  type = tuple([string, number, bool])
}

# Complex variable with validation
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
  
  validation {
    condition     = contains(["t2.micro", "t2.small", "t2.medium"], var.instance_type)
    error_message = "Instance type must be t2.micro, t2.small, or t2.medium."
  }
}

# Sensitive variable
variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}
```

### Variable Usage
```hcl
# Using variables
resource "aws_instance" "example" {
  instance_type = var.instance_type
  ami           = var.ami_id
  
  tags = {
    Name = "${var.project_name}-instance"
  }
}

# Variable files (terraform.tfvars)
instance_type = "t2.small"
project_name  = "myproject"
environment   = "production"

# Custom variable file (prod.tfvars)
# Usage: terraform apply -var-file="prod.tfvars"

# Command line variables
# terraform apply -var="instance_type=t2.large"

# Environment variables
# TF_VAR_instance_type=t2.large terraform apply
```

## Outputs

### Output Declaration
```hcl
# Basic output
output "instance_ip" {
  value = aws_instance.example.public_ip
}

# Output with description
output "instance_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the web server"
}

# Sensitive output
output "db_password" {
  value     = random_password.db.result
  sensitive = true
}

# Conditional output
output "instance_ip" {
  value = var.create_instance ? aws_instance.example[0].public_ip : null
}

# Complex output
output "instance_info" {
  value = {
    id         = aws_instance.example.id
    public_ip  = aws_instance.example.public_ip
    private_ip = aws_instance.example.private_ip
  }
}

# Output from module
output "vpc_id" {
  value = module.vpc.vpc_id
}
```

## Data Sources

### Using Data Sources
```hcl
# Find latest AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Use data source
resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
}

# Current AWS account info
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# Availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# External data source
data "external" "example" {
  program = ["python", "${path.module}/external.py"]
  
  query = {
    id = "example-id"
  }
}
```

## Locals

### Local Values
```hcl
locals {
  # Simple locals
  project_name = "myapp"
  environment  = "production"
  
  # Computed locals
  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
  
  # Complex expressions
  instance_name = "${local.project_name}-${local.environment}-instance"
  
  # Using functions
  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    min(3, length(data.aws_availability_zones.available.names))
  )
}

# Using locals
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = merge(
    local.common_tags,
    {
      Name = local.instance_name
    }
  )
}
```

## Modules

### Creating a Module
```hcl
# modules/vpc/variables.tf
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "public_subnet_count" {
  type        = number
  description = "Number of public subnets"
  default     = 2
}

# modules/vpc/main.tf
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count             = var.public_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = {
    Name = "${var.project_name}-public-${count.index + 1}"
  }
}

# modules/vpc/outputs.tf
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "IDs of public subnets"
}
```

### Using Modules
```hcl
# Local module
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_count = 3
  project_name        = "myapp"
}

# Git module
module "vpc" {
  source = "git::https://github.com/example/terraform-modules.git//vpc?ref=v1.0.0"
  
  vpc_cidr = "10.0.0.0/16"
}

# Terraform Registry module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

# Module with for_each
module "s3_buckets" {
  source   = "./modules/s3-bucket"
  for_each = toset(["assets", "logs", "backups"])
  
  bucket_name = "${var.project_name}-${each.key}"
}
```

## State Management

### State Commands
```bash
# List resources in state
terraform state list

# Show specific resource
terraform state show aws_instance.example

# Move resource in state
terraform state mv aws_instance.old aws_instance.new

# Remove resource from state
terraform state rm aws_instance.example

# Pull remote state
terraform state pull > terraform.tfstate

# Push state to remote
terraform state push terraform.tfstate

# Replace provider
terraform state replace-provider hashicorp/aws registry.custom.com/aws
```

### Remote State
```hcl
# S3 backend
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

# Using remote state data
data "terraform_remote_state" "network" {
  backend = "s3"
  
  config = {
    bucket = "my-terraform-state"
    key    = "network/terraform.tfstate"
    region = "us-west-2"
  }
}

# Access remote state outputs
resource "aws_instance" "example" {
  subnet_id = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
}
```

## Expressions and Functions

### Built-in Functions
```hcl
# String functions
upper("hello")                    # "HELLO"
lower("HELLO")                    # "hello"
title("hello world")              # "Hello World"
substr("hello world", 0, 5)       # "hello"
replace("hello world", "world", "terraform") # "hello terraform"
split(",", "a,b,c")               # ["a", "b", "c"]
join("-", ["a", "b", "c"])        # "a-b-c"
trim(" hello ", " ")              # "hello"
trimprefix("helloworld", "hello") # "world"
trimsuffix("helloworld", "world") # "hello"
format("Hello, %s!", "World")     # "Hello, World!"
formatlist("Hello, %s!", ["Alice", "Bob"]) # ["Hello, Alice!", "Hello, Bob!"]

# Numeric functions
abs(-5)                # 5
ceil(4.3)             # 5
floor(4.7)            # 4
max(1, 2, 3)          # 3
min(1, 2, 3)          # 1
pow(2, 3)             # 8
signum(-5)            # -1

# Collection functions
length(["a", "b", "c"])                    # 3
element(["a", "b", "c"], 1)                # "b"
index(["a", "b", "c"], "b")                # 1
contains(["a", "b", "c"], "b")             # true
keys({a = 1, b = 2})                       # ["a", "b"]
values({a = 1, b = 2})                     # [1, 2]
lookup({a = 1, b = 2}, "a", 0)             # 1
merge({a = 1}, {b = 2})                    # {a = 1, b = 2}
slice(["a", "b", "c", "d"], 1, 3)          # ["b", "c"]
concat(["a", "b"], ["c", "d"])             # ["a", "b", "c", "d"]
distinct(["a", "b", "a", "c"])             # ["a", "b", "c"]
flatten([["a", "b"], ["c"]])               # ["a", "b", "c"]
setproduct(["a", "b"], ["1", "2"])         # [["a", "1"], ["a", "2"], ["b", "1"], ["b", "2"]]

# Type conversion functions
tostring(123)              # "123"
tonumber("123")            # 123
tobool("true")             # true
tolist(["a", "b", "c"])    # ["a", "b", "c"]
toset(["a", "b", "a"])     # ["a", "b"]
tomap({a = 1, b = 2})      # {a = 1, b = 2}

# Encoding functions
base64encode("hello")           # "aGVsbG8="
base64decode("aGVsbG8=")        # "hello"
jsonencode({a = 1, b = 2})      # "{\"a\":1,\"b\":2}"
jsondecode("{\"a\":1,\"b\":2}") # {a = 1, b = 2}
yamlencode({a = 1, b = 2})      # "a: 1\nb: 2\n"
yamldecode("a: 1\nb: 2")        # {a = 1, b = 2}

# Filesystem functions
file("${path.module}/file.txt")            # Read file content
fileexists("${path.module}/file.txt")      # true/false
fileset("${path.module}", "*.tf")          # Set of matching files
templatefile("${path.module}/template.tpl", {var = "value"})

# Date and time functions
timestamp()                              # Current timestamp
timeadd(timestamp(), "24h")              # Add 24 hours
formatdate("YYYY-MM-DD", timestamp())    # Format timestamp

# Hash and crypto functions
md5("hello")                    # MD5 hash
sha256("hello")                 # SHA256 hash
bcrypt("password", 10)          # Bcrypt hash
uuid()                          # Generate UUID
random_id.example.hex           # Random ID

# IP network functions
cidrhost("10.0.0.0/16", 5)         # "10.0.0.5"
cidrnetmask("10.0.0.0/16")         # "255.255.0.0"
cidrsubnet("10.0.0.0/16", 8, 2)    # "10.0.2.0/24"
```

### Dynamic Expressions
```hcl
# Conditional expression
instance_type = var.environment == "production" ? "t2.large" : "t2.micro"

# For expression (list)
subnet_ids = [for s in aws_subnet.public : s.id]

# For expression (map)
instance_ips = {for i in aws_instance.example : i.tags.Name => i.public_ip}

# For expression with filter
prod_instances = [for i in aws_instance.example : i.id if i.tags.Environment == "production"]

# Splat expression
instance_ids = aws_instance.example[*].id

# Dynamic blocks
resource "aws_security_group" "example" {
  name = "example"
  
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

## Conditionals and Loops

### Count and For_Each
```hcl
# Count with conditional
resource "aws_instance" "example" {
  count = var.create_instance ? 1 : 0
  
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

# For_each with map
resource "aws_instance" "example" {
  for_each = {
    web = "t2.micro"
    app = "t2.small"
    db  = "t2.medium"
  }
  
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = each.value
  
  tags = {
    Name = "${each.key}-server"
  }
}

# For_each with set
resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  
  name = each.value
}

# Conditional resource creation
resource "aws_eip" "example" {
  count    = var.create_eip ? 1 : 0
  instance = aws_instance.example[0].id
}
```

### Dynamic Blocks
```hcl
# Dynamic block in resource
resource "aws_autoscaling_group" "example" {
  # ... other configuration ...
  
  dynamic "tag" {
    for_each = var.custom_tags
    
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# Nested dynamic blocks
resource "aws_network_acl" "example" {
  vpc_id = aws_vpc.main.id
  
  dynamic "ingress" {
    for_each = var.ingress_rules
    
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = "allow"
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }
}
```

## Provisioners

### Types of Provisioners
```hcl
# File provisioner
resource "aws_instance" "example" {
  # ... instance configuration ...
  
  provisioner "file" {
    source      = "conf/myapp.conf"
    destination = "/etc/myapp.conf"
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}

# Remote-exec provisioner
resource "aws_instance" "example" {
  # ... instance configuration ...
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx"
    ]
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}

# Local-exec provisioner
resource "aws_instance" "example" {
  # ... instance configuration ...
  
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ip_addresses.txt"
  }
  
  # Run on destroy
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Instance ${self.id} destroyed' >> log.txt"
  }
}

# Null resource with provisioner
resource "null_resource" "example" {
  triggers = {
    cluster_instance_ids = join(",", aws_instance.cluster[*].id)
  }
  
  provisioner "local-exec" {
    command = "ansible-playbook -i '${join(",", aws_instance.cluster[*].public_ip)},' playbook.yml"
  }
}
```

## Workspaces

### Workspace Commands
```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new dev
terraform workspace new prod

# Select workspace
terraform workspace select dev

# Show current workspace
terraform workspace show

# Delete workspace
terraform workspace delete dev
```

### Using Workspaces in Configuration
```hcl
# Reference current workspace
resource "aws_instance" "example" {
  count = terraform.workspace == "prod" ? 5 : 1
  
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = terraform.workspace == "prod" ? "t2.large" : "t2.micro"
  
  tags = {
    Name        = "instance-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# Workspace-specific variables
locals {
  instance_count = {
    dev  = 1
    prod = 5
  }
  
  instance_type = {
    dev  = "t2.micro"
    prod = "t2.large"
  }
}

resource "aws_instance" "example" {
  count         = local.instance_count[terraform.workspace]
  instance_type = local.instance_type[terraform.workspace]
  # ...
}
```

## Import and Move

### Importing Resources
```bash
# Import existing resource
terraform import aws_instance.example i-1234567890abcdef0

# Import with for_each
terraform import 'aws_instance.example["web"]' i-1234567890abcdef0

# Import with count
terraform import 'aws_instance.example[0]' i-1234567890abcdef0

# Import module resource
terraform import module.vpc.aws_vpc.main vpc-1234567890abcdef0
```

### Import Block (Terraform 1.5+)
```hcl
import {
  to = aws_instance.example
  id = "i-1234567890abcdef0"
}

# Generate configuration for imported resource
# terraform plan -generate-config-out=generated.tf
```

### Moving Resources
```hcl
# Moved block (Terraform 1.1+)
moved {
  from = aws_instance.example
  to   = aws_instance.web_server
}

# Moving resources between modules
moved {
  from = aws_instance.example
  to   = module.compute.aws_instance.example
}
```

## Terraform Commands

### Essential Commands
```bash
# Initialize Terraform
terraform init
terraform init -upgrade              # Upgrade providers
terraform init -reconfigure          # Reconfigure backend
terraform init -backend-config=backend.hcl

# Format code
terraform fmt
terraform fmt -recursive             # Format all files recursively
terraform fmt -check                 # Check if formatted

# Validate configuration
terraform validate

# Plan changes
terraform plan
terraform plan -out=tfplan           # Save plan
terraform plan -var="key=value"      # Set variable
terraform plan -target=resource.name # Target specific resource
terraform plan -destroy              # Plan destroy

# Apply changes
terraform apply
terraform apply tfplan               # Apply saved plan
terraform apply -auto-approve        # Skip confirmation
terraform apply -parallelism=10      # Set parallelism

# Destroy infrastructure
terraform destroy
terraform destroy -auto-approve
terraform destroy -target=resource.name

# Show resources
terraform show                       # Show current state
terraform show tfplan                # Show saved plan

# Output values
terraform output
terraform output instance_ip         # Specific output
terraform output -json               # JSON format

# Refresh state
terraform refresh

# Graph dependencies
terraform graph | dot -Tpng > graph.png

# Console (REPL)
terraform console

# Force unlock state
terraform force-unlock LOCK_ID

# Taint resource (deprecated, use -replace)
terraform taint aws_instance.example

# Replace resource
terraform apply -replace="aws_instance.example"

# Test (Terraform 1.6+)
terraform test
```

## Best Practices

### Project Structure
```
terraform-project/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── backend.tf
├── modules/
│   ├── networking/
│   ├── compute/
│   └── storage/
└── global/
    ├── iam/
    └── s3/
```

### Naming Conventions
```hcl
# Resources: use underscores
resource "aws_instance" "web_server" { }

# Variables: use underscores
variable "instance_type" { }

# Outputs: use underscores
output "instance_public_ip" { }

# Locals: use underscores
locals {
  common_tags = { }
}

# Files
# main.tf        - Main configuration
# variables.tf   - Variable declarations
# outputs.tf     - Output declarations
# versions.tf    - Provider requirements
# backend.tf     - Backend configuration
```

### Security Best Practices
```hcl
# Never commit sensitive data
# Use .gitignore
*.tfvars
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl

# Use sensitive variables
variable "db_password" {
  type      = string
  sensitive = true
}

# Use AWS Secrets Manager
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/db/password"
}

# Use environment variables
# TF_VAR_db_password=secret123

# Encrypt state files
terraform {
  backend "s3" {
    encrypt = true
    # ...
  }
}
```

### Version Constraints
```hcl
# Terraform version
terraform {
  required_version = ">= 1.0, < 2.0"
}

# Provider versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # >= 5.0, < 6.0
    }
  }
}

# Module versions
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"  # Pin to specific version
}

# Version operators
# = : Exact version
# != : Not equal
# >, >=, <, <= : Comparisons
# ~> : Pessimistic constraint
```

## Common Patterns

### Blue-Green Deployment
```hcl
variable "deployment_color" {
  default = "blue"
}

resource "aws_instance" "app" {
  count = var.deployment_color == "blue" ? var.instance_count : 0
  # ... blue configuration
}

resource "aws_instance" "app_green" {
  count = var.deployment_color == "green" ? var.instance_count : 0
  # ... green configuration
}

resource "aws_lb_target_group_attachment" "app" {
  count            = var.deployment_color == "blue" ? var.instance_count : 0
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app[count.index].id
}
```

### Multi-Region Deployment
```hcl
variable "regions" {
  default = ["us-east-1", "us-west-2", "eu-west-1"]
}

provider "aws" {
  for_each = toset(var.regions)
  alias    = each.key
  region   = each.key
}

module "app" {
  for_each = toset(var.regions)
  source   = "./modules/app"
  
  providers = {
    aws = aws[each.key]
  }
  
  region = each.key
}
```

### Zero-Downtime Updates
```hcl
resource "aws_autoscaling_group" "app" {
  name                = "${aws_launch_configuration.app.name}-asg"
  launch_configuration = aws_launch_configuration.app.name
  
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  
  # Enable zero-downtime deployments
  lifecycle {
    create_before_destroy = true
  }
  
  # Use name prefix to force new ASG
  name_prefix = "app-asg-"
}
```

## Debugging and Troubleshooting

### Debug Output
```bash
# Enable debug logging
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log

# Log levels: TRACE, DEBUG, INFO, WARN, ERROR

# Specific provider debugging
export TF_LOG_PROVIDER=DEBUG

# Core debugging
export TF_LOG_CORE=DEBUG
```

### Common Issues and Solutions
```hcl
# Issue: Cycle error
# Solution: Remove circular dependencies or use depends_on carefully

# Issue: Resource already exists
# Solution: Import the resource or use different naming

# Issue: State lock timeout
# Solution: terraform force-unlock LOCK_ID

# Issue: Provider version conflicts
# Solution: Run terraform init -upgrade

# Issue: Variable not found
# Solution: Check variable declaration and tfvars files
```

### Validation and Testing
```hcl
# Validate syntax
terraform validate

# Check formatting
terraform fmt -check -recursive

# Use preconditions/postconditions
resource "aws_instance" "example" {
  # ...
  
  lifecycle {
    precondition {
      condition     = var.instance_type != "t2.nano"
      error_message = "Instance type t2.nano is not supported."
    }
    
    postcondition {
      condition     = self.public_ip != ""
      error_message = "Instance must have a public IP."
    }
  }
}

# Terraform test framework (1.6+)
# tests/instance.tftest.hcl
run "instance_test" {
  command = plan
  
  assert {
    condition     = aws_instance.example.instance_type == "t2.micro"
    error_message = "Instance type should be t2.micro"
  }
}
```

## Backend Configuration

### S3 Backend with DynamoDB Lock
```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "path/to/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    
    # Role ARN for cross-account access
    role_arn = "arn:aws:iam::123456789012:role/TerraformRole"
  }
}

# Create S3 bucket for state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create DynamoDB table for locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }
}
```

### Other Backend Types
```hcl
# Local backend (default)
terraform {
  backend "local" {
    path = "relative/path/to/terraform.tfstate"
  }
}

# Consul backend
terraform {
  backend "consul" {
    address = "consul.example.com:8500"
    scheme  = "https"
    path    = "terraform/state"
  }
}

# Azure Storage backend
terraform {
  backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup"
    storage_account_name = "abcd1234"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

# Google Cloud Storage backend
terraform {
  backend "gcs" {
    bucket = "tf-state-bucket"
    prefix = "terraform/state"
  }
}
```

## Tips and Tricks

### Performance Optimization
```hcl
# Parallelize operations
terraform apply -parallelism=10

# Target specific resources
terraform apply -target=module.vpc

# Refresh specific resources
terraform apply -refresh-only -target=aws_instance.example

# Use data sources efficiently
data "aws_ami" "example" {
  # Cache results with locals
  most_recent = true
  # ...
}

locals {
  ami_id = data.aws_ami.example.id
}
```

### Advanced Patterns
```hcl
# Self-referencing with for_each
resource "aws_security_group_rule" "ingress" {
  for_each = var.ports
  
  type              = "ingress"
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example.id
}

# Complex type constraints
variable "complex_object" {
  type = list(object({
    name = string
    settings = object({
      size    = number
      enabled = bool
      tags    = map(string)
    })
  }))
}

# Optional attributes (Terraform 1.3+)
variable "optional_object" {
  type = object({
    name     = string
    nickname = optional(string, "default")
    age      = optional(number)
  })
}
```

---

*This cheatsheet covers Terraform 1.x syntax and features. Keep it handy for infrastructure as code development!*