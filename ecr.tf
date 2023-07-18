data "aws_kms_alias" "kmsKey"{
  name = "alias/aws/secretsmanager"
}

resource "aws_ecr_repository" "example" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"
  force_delete = true

  # encryption configuration 
  encryption_configuration  {
    #encryption_type = "AES256"
    encryption_type = "KMS"
    kms_key = "alias/Advance/rdskey"
    #kms_key = data.aws_kms_alias.kmsKey.arn
  }

  # image_scanning_configuration {
  #  scan_on_push = true
  # }
  tags = {
    Name = var.ecr_name
    environment = var.environment
  }  
}
######## manager registry scanning configuration 
resource "aws_ecr_registry_scanning_configuration" "example" {
  scan_type = "ENHANCED"

  rule {
    scan_frequency = "SCAN_ON_PUSH"
    repository_filter {
      filter      = "*"
      filter_type = "WILDCARD"
    }
  }

  rule {
    scan_frequency = "CONTINUOUS_SCAN"
    repository_filter {
      filter      = "example"
      filter_type = "WILDCARD"
    }
  }
}

########
resource "aws_ecr_lifecycle_policy" "examplepolicy" {
  repository = aws_ecr_repository.example.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

data "aws_vpc" "vpc"{
  filter {
    name = "tag:Name"
    values = ["vpc-main"]
  }
}

output "vpcid"{
  value = data.aws_vpc.vpc.id
}
output "vpc_cidr"{
  value = data.aws_vpc.vpc.cidr_block
}

data "aws_subnet" "selected" {
  filter {
    name = "tag:Name"
    values = ["private0"]
  }
}
# output "VPC_ID" {
#   value = data.aws_subnet.selected.vpc_id
# }
output "cidr_block" {
  value = data.aws_subnet.selected.cidr_block
}
data "aws_iam_role" "execution" {
  name = "AWSServiceRoleForECS"
}

output "ECSServicerole"{
  value = data.aws_iam_role.execution.arn
}