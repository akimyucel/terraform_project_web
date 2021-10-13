variable "base_domain" {
  type    = string
  default = "akimyucel.com"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_id" {
  type    = string
  default = "vpc-554d4b2d"
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-080a9a70", "subnet-5d873a17"]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "asg_max" {
  type    = number
  default = 5
}

variable "asg_desired" {
  type    = number
  default = 3
}