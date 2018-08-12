//provider "aws" {
//  region = "eu-west-1"
//}

//variable "number_of_instances" {
//  description = "Number of instances to create and attach to ELB"
//  default     = 3
//}

##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
//data "aws_vpc" "selected" {
//  vpc_id = "${aws_vpc.demo.id}"
//}

data "aws_subnet_ids" "all" {
  vpc_id = "${aws_vpc.demo.id}"
}

data "aws_security_group" "default" {
  vpc_id = "${aws_vpc.demo.id}"
  name   = "default"
}

######
# ELB
######
resource "aws_elb" "ingress" {
  name = "elb-${var.cluster-name}"

  subnets         = ["${data.aws_subnet_ids.all.ids}"]
  security_groups = ["${data.aws_security_group.default.id}"]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
    {
      instance_port     = "8080"
      instance_protocol = "HTTP"
      lb_port           = "8080"
      lb_protocol       = "HTTP"
    },
  ]

  health_check = [
    {
      target              = "HTTP:80/"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]

  tags = {
    Environment = "demo"
  }

  //  # ELB attachments
  //  number_of_instances = "${var.number_of_instances}"
  //  instances           = ["${module.ec2_instances.id}"]
}

//# Create a new load balancer attachment
//resource "aws_elb_attachment" "demo" {
//  elb      = "${aws_elb.ingress.id}"
//  instance = "${aws_autoscaling_group.demo.id}"
//}


################
# EC2 instances
################
//module "ec2_instances" {
//  source = "terraform-aws-modules/ec2-instance/aws"
//
//  instance_count = "${var.number_of_instances}"
//
//  name                        = "my-app"
//  ami                         = "ami-ebd02392"
//  instance_type               = "t2.micro"
//  vpc_security_group_ids      = ["${data.aws_security_group.default.id}"]
//  subnet_id                   = "${element(data.aws_subnet_ids.all.ids, 0)}"
//  associate_public_ip_address = true
//}


################
# OUTOUTS
################
# ELB
//output "this_elb_id" {
//  description = "The name of the ELB"
//  value       = "${module.elb.this_elb_id}"
//}
//
//output "this_elb_name" {
//  description = "The name of the ELB"
//  value       = "${module.elb.this_elb_name}"
//}
//
//output "this_elb_dns_name" {
//  description = "The DNS name of the ELB"
//  value       = "${module.elb.this_elb_dns_name}"
//}
//
//output "this_elb_instances" {
//  description = "The list of instances in the ELB (if may be outdated, because instances are attached using elb_attachment resource)"
//  value       = ["${module.elb.this_elb_instances}"]
//}
//
//output "this_elb_source_security_group_id" {
//  description = "The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances"
//  value       = "${module.elb.this_elb_source_security_group_id}"
//}
//
//output "this_elb_zone_id" {
//  description = "The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)"
//  value       = "${module.elb.this_elb_zone_id}"
//}

