provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-ansible-jenkins"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

resource "aws_instance" "my_ec2" {
  ami             = "ami-04b4f1a9cf54c11d0"  # Update with the latest AMI ID
  instance_type   = "t2.micro"
  key_name        = "my-aws-key"
  security_groups = ["sg-0e4255cb9921c3cfe"]

  tags = {
    Name = "Jenkins-Provisioned-EC2"
  }
}
