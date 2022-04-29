
#VPC

resource "aws_vpc" "vpc0" {
  cidr_block       = "192.168.1.0/24"
  tags = {
    name = "vpc0"
  }
}

resource "aws_subnet" "sub0" {
  vpc_id = aws_vpc.vpc0.id
  cidr_block = "192.168.1.0/25"
  availability_zone = "us-east-1a"
}


#Security Groups

resource "aws_security_group" "sg0" {
  description = "security-group"
  vpc_id      = aws_vpc.vpc0.id
  egress      = [
    {
      cidr_blocks      = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress     = [
    {
      cidr_blocks      = [
        "0.0.0.0/0",
      ]
      description      = "Permitir todo o iCMP"
      from_port        = -1
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "icmp"
      security_groups  = []
      self             = false
      to_port          = -1
    },
    {
      cidr_blocks      = [
        "78.29.147.32/32",
      ]
      description      = "Permitir todo o DNS vindo do meu IP"
      from_port        = 53
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "udp"
      security_groups  = []
      self             = false
      to_port          = 53
    },
    {
      cidr_blocks      = [
        "78.29.147.32/32",
      ]
      description      = "Permitir todo o HTTPS vindo do meu IP"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },
    {
      cidr_blocks      = []
      description      = "Permitir todo o HTTP vindo de IPv6"
      from_port        = 80
      ipv6_cidr_blocks = [
        "::/0",
      ]
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
  ]
  name        = "grsi-security-group"
  tags        = {}
  tags_all    = {}

  timeouts {}

}


#Maquinas

variable "user_data"{
 default= "./server.sh" 
}

resource "aws_instance" "grsi" {
  depends_on = [ aws_security_group.sg0 ]
  ami                                  = "ami-0f9fc25dd2506cf6d"
 associate_public_ip_address          = true
 availability_zone                    = "us-east-1a"
  instance_type                        = "t2.micro"
  key_name                             = "vockey"
  subnet_id = aws_subnet.sub0.id
  
  vpc_security_group_ids = [
    aws_security_group.sg0.id,
  ]

  
  tags = {
      Name = "Server"
  }
}

variable "user_data1"{
 default= "./client.sh" 
}

resource "aws_instance" "client" {
  depends_on = [ aws_security_group.sg0 ]
  ami                                  = "ami-0f9fc25dd2506cf6d"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1a"
  instance_type                        = "t2.micro"
  key_name                             = "vockey"
  subnet_id = aws_subnet.sub0.id
    
  vpc_security_group_ids = [
    aws_security_group.sg0.id,
  ]

  
  tags = {
      Name = "client"
  }
}


#Elastic IPs

resource "aws_eip" "eip0" {
  instance = aws_instance.grsi.id
  vpc = true
}


resource "aws_eip" "eip1" {
  instance = aws_instance.client.id
  vpc = true
}

