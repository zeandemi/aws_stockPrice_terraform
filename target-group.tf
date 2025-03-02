#creating target group for the nodes
resource "aws_lb_target_group" "aws_node_lb_TG" {
  health_check {
    interval = 10
    path = "/"
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
  }
  name = "PrivateTG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    name = "Private Node TG"
  }
}

resource "aws_lb_target_group" "aws_node_lb_TG_Public" {
  health_check {
    interval = 10
    path = "/"
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
  }
  name = "PublicTG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    name = "Public Node TG"
  }
}
resource "aws_lb_target_group_attachment" "private_TG_attachment" {
  target_group_arn = aws_lb_target_group.aws_node_lb_TG.arn
  target_id = aws_lb.private_subnet_alb.id
  port = 80
}

resource "aws_lb_target_group_attachment" "public_TG_attachment" { 
  target_group_arn = aws_lb_target_group.aws_node_lb_TG_Public.arn
  target_id = aws_lb.public_subnet_alb.id
  port = 80
}