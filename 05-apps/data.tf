data "aws_ssm_parameter" "backend_sg_id" {
  name = "/${var.Project_name}/${var.environment}/backend_sg_id"
}

data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.Project_name}/${var.environment}/frontend_sg_id"
}

data "aws_ssm_parameter" "ansible_sg_id" {
  name = "/${var.Project_name}/${var.environment}/ansible_sg_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.Project_name}/${var.environment}/private_subnet_id"
}

data "aws_ssm_parameter" "publicd_subnet_ids" {
  name = "/${var.Project_name}/${var.environment}/public_subnet_id"
}

data "aws_ami" "ami_info" {

    owners = ["973714476881"]
    most_recent = true

    filter {
        name = "name"
        values = ["RHEL-9-DevOps-Practice"]
 
    }
    filter {
        name = "root-device-type"
        values = ["ebs"]
    }


    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}