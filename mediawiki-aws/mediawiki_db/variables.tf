#RDS Instance variables

variable "vpc_id" {
  default = "vpc-id"
}
variable "mediawiki_dbserver_instance_type" {
  default = "t2.micro"
}

variable "mediawiki_dbserver_subnet_id" {
  default = "subnet"
}

variable "key_pair_name" {
  default = "key"
}
variable "mediawiki_dbserver_ami_id" {
  default="ami-030db555e7f919682"
}

variable "env" {
  default = "dev"
}
variable "stack" {
    default ="mediawiki"
}
variable "service"   {
    default ="mediawiki"
}

variable "name" {
  default = "mediawiki-db"
}
