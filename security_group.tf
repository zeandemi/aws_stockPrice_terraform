resource "aws_security_group" "private_node_group" {
  depends_on = [
    aws_subnet.public_Subnet,
    aws_subnet.private_Subnet
  ]
  name        = "private_instance"
  description = "allow inbound traffic"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    description = "Inbound from public subnet"
    from_port   = 0    # all traffic
    to_port     = 0    # all traffic
    protocol    = "-1" # all traffic
    cidr_blocks = [
      "${aws_subnet.public_Subnet[0].cidr_block}",
      "${aws_subnet.public_Subnet[1].cidr_block}",
      "${aws_subnet.public_Subnet[2].cidr_block}"
    ]
  }

  egress {
    description = "Outbound from public subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "${aws_subnet.public_Subnet[0].cidr_block}",
      "${aws_subnet.public_Subnet[1].cidr_block}",
      "${aws_subnet.public_Subnet[2].cidr_block}"
    ]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "private_SC_rule"
  }
}

resource "aws_security_group" "public_node_group" {
  depends_on = [
    aws_subnet.public_Subnet,
    aws_subnet.private_Subnet
  ]
  name        = "public_instance"
  description = "allow inbound traffic"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    description = "Inbound from internet"
    from_port   = 0    # all traffic
    to_port     = 0    # all traffic
    protocol    = "-1" # all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound from internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "public_SC_rule"
  }
}

#security group for redis
resource "aws_security_group" "redis_sg"{
  vpc_id = aws_vpc.eks_vpc.id
  name = "redis instance"

  ingress {
    description = "Inbound from private subnet"
    from_port   = 6379    # all traffic
    to_port     = 6379    # all traffic
    protocol    = "tcp" # all traffic
    cidr_blocks = [
      "${aws_subnet.private_Subnet[0].cidr_block}",
      "${aws_subnet.private_Subnet[1].cidr_block}",
      "${aws_subnet.private_Subnet[2].cidr_block}"
    ]
  }

  egress {
    description = "Outbound from internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"] # Allow only internal VPC access
  }

  tags = {
    Name = "redis security group"
  }
}
