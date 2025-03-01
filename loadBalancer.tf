#ALB private
resource "aws_lb" "private_subnet_alb" {
  name = "privateSubnetAlb"
  internal = false
  security_groups = [aws_security_group.private_node_group.id]
  subnets = [
    "${aws_subnet.private_Subnet[1].id}",
    "${aws_subnet.private_Subnet[2].id}"
  ]
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  depends_on = [ aws_subnet.private_Subnet ]
}

#ALB for public
resource "aws_lb" "public_subnet_alb" {
  name = "publicSubnetAlb"
  internal = false
  security_groups = [aws_security_group.public_node_group.id]
  subnets = [
    "${aws_subnet.public_Subnet[1].id}",
    "${aws_subnet.public_Subnet[2].id}"
  ]
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  depends_on = [ aws_subnet.public_Subnet ]
}

resource "aws_lb_listener" "private_alb_listerner" {  
  load_balancer_arn = aws_lb.private_subnet_alb.arn
  protocol = "HTTP"
  port = 80
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.aws_node_lb_TG.arn
  }
}

resource "aws_lb_listener" "public_alb_listerner" {
  load_balancer_arn = aws_lb.public_subnet_alb.arn
  protocol = "HTTP"
  port = 80
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.aws_node_lb_TG_Public.arn
  }
}