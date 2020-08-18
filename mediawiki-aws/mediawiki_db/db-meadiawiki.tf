resource "aws_instance" "mediawiki_dbserver" {
  ami             = "${var.mediawiki_dbserver_ami_id}"
  instance_type   = "${var.mediawiki_dbserver_instance_type}"
  key_name        = "${var.key_pair_name}"
  vpc_security_group_ids = ["${aws_security_group.mediawiki_dbserver_sg.id}"]
  user_data       = "${file("${path.module}/../templates/user_data_mediawiki_dbserver.sh.tpl")}"
 

  tags {
    Name        = "${var.env}-${var.stack}-db"
    env         = "${var.env}"
    stack       = "${var.stack}"
    
  }

  subnet_id = "${var.mediawiki_dbserver_subnet_id}"


}

resource "aws_security_group" "mediawiki_dbserver_sg" {
  name        = "${var.env}-${var.stack}-db-node-sg"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "mediawiki_dbserver_ingress_allow" {
  type              = "ingress"
  to_port           = 65535
  protocol          = "TCP"
  from_port         = 1
  cidr_blocks       = ["172.27.0.0/16"]
  security_group_id = "${aws_security_group.mediawiki_dbserver_sg.id}"
}

resource "aws_security_group_rule" "mediawiki_dbserver_allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.mediawiki_dbserver_sg.id}"
}


resource "aws_route53_record" "wikidbrecord" {
  allow_overwrite = true
  name            = "mediawiki-db"
  ttl             = 30
  type            = "A"
  zone_id         = "hostedzone"

  records = [
      "${aws_instance.mediawiki_dbserver.private_ip}"
  ]
}

