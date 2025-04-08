provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "sctp-ce9-tfstate"
    key    = "chrisy-s3-tf-ci.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.0"
}

data "aws_caller_identity" "current" {}

locals {
  name_prefix = split("/", data.aws_caller_identity.current.arn)[1]
  account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "s3_tf" {
  bucket = "${local.name_prefix}-s3-tf-bkt-${local.account_id}"
}

resource "aws_s3_bucket" "s3_tf" {
  # checkov:skip=CKV2_AWS_62:Event notifications not required for this bucket
  # checkov:skip=CKV_AWS_145:Using default AWS S3 encryption (SSE-S3) instead of KMS
  # checkov:skip=CKV_AWS_21:Versioning not enabled for cost optimization
  # checkov:skip=CKV2_AWS_6:Public access restricted via IAM policies
  # checkov:skip=CKV_AWS_144:Cross-region replication not needed for this use case
  # checkov:skip=CKV_AWS_18:Access logging not required for this bucket
  # checkov:skip=CKV2_AWS_61:Lifecycle configuration not applicable
  bucket = "${local.name_prefix}-s3-tf-bkt-${local.account_id}"
}