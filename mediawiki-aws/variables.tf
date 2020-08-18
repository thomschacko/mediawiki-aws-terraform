variable "mediawiki_cluster_ami_id" {
  default ="ami-030db555e7f919682"
}
variable "mediawiki_cluster_instance_type" {
  default ="t3a.medium"
}
variable "key_pair_name" {
  default ="-key"
}
variable "vpc_id" {
  default ="vpc-id"
}

variable "env" {
  default ="dev"
}
variable "stack" {
  default="mediawiki"
}
variable "service" {
  default="ui"
}

variable "mediawiki_cluster_subnet_id_1" {
  default="subnet-id-private"
}
variable "mediawiki_cluster_subnet_id_2" {
  default ="subnet-id-public"
}


