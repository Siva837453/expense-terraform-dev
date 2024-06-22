module "backend_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.Project_name}-${var.environment}-backend"

  instance_type          = "t3.micro"
  
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
  #converting StringList to list
  subnet_id              = local.private_subnet_id
  ami = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,
    {
        Name= "${var.Project_name}-${var.environment}-backend"
    }

  )
}

module "frontend_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.Project_name}-${var.environment}-frontend"

  instance_type          = "t3.micro"
  
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]
  #converting StringList to list
  subnet_id              = local.public_subnet_id
  ami = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,
    {
        Name= "${var.Project_name}-${var.environment}-frontend"
    }

  )
}

module "ansible_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.Project_name}-${var.environment}-ansible"

  instance_type          = "t3.micro"
  
  vpc_security_group_ids = [data.aws_ssm_parameter.ansible_sg_id.value]
  #converting StringList to list
  subnet_id              = local.public_subnet_id
  ami = data.aws_ami.ami_info.id
  user_data = file("expense.sh")

  tags = merge(
    var.common_tags,
    {
        Name= "${var.Project_name}-${var.environment}-ansible"
    }
  )
  depends_on = [ module.backend_instance,module.frontend_instance ]
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "backend"
      type    = "A"
      ttl     = 1
      records = [
        module.backend_instance.private_ip
      ]
    },

    {
      name    = "frontend"
      type    = "A"
      ttl     = 1
      records = [
        module.frontend_instance.private_ip
      ]
    },
    {
      name    = "" # sdevops.cloud
      type    = "A"
      ttl     = 1
      records = [
        module.frontend_instance.public_ip
      ]
    },
  ]
}