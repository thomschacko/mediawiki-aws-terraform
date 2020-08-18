provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "ap-south-1"
}
#invoking module for DB

module "mediawiki_mysqlserver" {
  source = "./mediawiki_db"

}



data "template_file" "mediawiki_cluster_userdata" {
  template = "${file("${path.module}/templates/mediawiki_cluster_userdata.sh.tpl")}"

  vars {

    env           = "${var.env}"
    stack         = "${var.stack}"
    
  }

}



resource "aws_elb" "mediawiki_cluster_lb" {
name               = "${var.env}-${var.stack}-elb"
security_groups    = ["${module.mediawiki_ui_sg.security_group_id}"]
subnets            = ["${var.mediawiki_cluster_subnet_id_2}"]



# Forward 8080
listener {
  instance_port     = 80
  instance_protocol = "http"
  lb_port           = 80
  lb_protocol       = "http"
}




  # TCP health check for 80


  health_check {
  healthy_threshold   = 2
  unhealthy_threshold = 2
  timeout             = 3
  target              = "TCP:80"
  interval            = 30
}

}



module "mediawiki_ui_sg" {
  source = "./sec-grps"
  vpc_id = "${var.vpc_id}"
}


# resource "aws_security_group" "mediawiki_sg" {
#   name        = "allomediawiki_sgw_tls"
#   description = "Allow  inbound traffic"
#   vpc_id      = "${var.vpc_id}"

#   ingress {
#     description = "http from everywhere"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "TCP"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "mediawiki_sg"
#   }
# }

###########################################################
#ASG and LC  for mediawiki
module "mediawiki_asg" {
  source = "./asg"

  name = "${var.stack}-cluster"
  lc_name = "${var.stack}-lc"
  image_id                     = "ami-030db555e7f919682"
  instance_type                = "t2.small"
  security_groups              = ["${module.mediawiki_ui_sg.security_group_id}"]
  associate_public_ip_address  = false
  recreate_asg_when_lc_changes = true
  load_balancers               = ["${aws_elb.mediawiki_cluster_lb.name}"]
  key_name                     = "${var.key_pair_name}"
  user_data                    = "${data.template_file.mediawiki_cluster_userdata.rendered}"



  # Auto scaling group
  asg_name                  = "${var.env}-${var.stack}-asg"
  vpc_zone_identifier       = ["${var.mediawiki_cluster_subnet_id_1}"]
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 4
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "env"
      value               = "${var.env}"
      propagate_at_launch = true
    },
    {
      key                 = "asg"
      value               = "true"
      propagate_at_launch = true
    },
  ]

  # CPU Scaling & Scale Down

  scale_up_threshold   = 60
  scale_down_threshold = 5
  cooldown_period      = 300
  evaluation_period    = 2
  alarm_period         = 120
}


