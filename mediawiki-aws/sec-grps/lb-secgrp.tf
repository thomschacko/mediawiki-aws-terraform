resource "aws_security_group" "mediawiki_sg" {
  name        = "allomediawiki_sgw_tls"
  description = "Allow  inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description = "http from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mediawiki_sg"
  }
}

