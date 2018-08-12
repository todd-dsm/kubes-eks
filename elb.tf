/*
-------------------------------------------------------------------------------
ELB for Inboun traffic
-------------------------------------------------------------------------------
*/
resource "aws_elb" "ingress" {
  name = "elb-${var.cluster-name}"

  subnets         = ["${aws_subnet.demo.*.id}"]
  security_groups = ["${aws_security_group.demo-node.id}"]
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
}

/*
-------------------------------------------------------------------------------
OUTOUTS
-------------------------------------------------------------------------------
*/
# ELB
//output "elb_ingress_id" {
//  description = "The name of the ELB"
//  value       = "${aws_elb.ingress.id}"
//}
//output "this_elb_name" {
//  description = "The name of the ELB"
//  value       = "${aws_elb.ingress.name}"
//}
//
//output "this_elb_dns_name" {
//  description = "The DNS name of the ELB"
//  value       = "${aws_elb.ingress.dns_name}"
//}
//
//output "this_elb_instances" {
//  description = "The list of instances in the ELB (if may be outdated, because instances are attached using elb_attachment resource)"
//  value       = ["${aws_elb.ingress.instances}"]
//}
//
//output "this_elb_source_security_group_id" {
//  description = "The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances"
//  value       = "${aws_elb.ingress.source_security_group_id}"
//}
//
//output "this_elb_zone_id" {
//  description = "The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)"
//  value       = "${aws_elb.ingress.zone_id}"
//}

