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
  depends_on = [aws_lb.private_subnet_alb]
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
  depends_on = [aws_lb.public_subnet_alb]
  tags = {
    name = "Public Node TG"
  }
}
/* resource "aws_lb_target_group_attachment" "private_TG_attachment" {
  target_group_arn = aws_lb_target_group.aws_node_lb_TG.arn
  target_id = aws_lb.private_subnet_alb.arn
  depends_on = [ aws_lb.private_subnet_alb ]
  port = 80
} */

/* resource "aws_lb_target_group_attachment" "public_TG_attachment" { 
  target_group_arn = aws_lb_target_group.aws_node_lb_TG_Public.arn
  target_id = aws_lb.public_subnet_alb.arn
  depends_on = [ aws_lb.public_subnet_alb ]
  port = 80
} */

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