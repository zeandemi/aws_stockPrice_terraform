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
  name = "TG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    name = "Node TG"
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
  name = "TG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    name = "Node TG"
  }
}

resource "aws_lb_target_group_attachment" "private_TG_attachment" {
  #count = length(local.subnets.public)
 
  for_each = {
   #  for node_id in data.aws_eks_node_group.public_node_group 
   # for k, v in aws_eks_node_group.private_nodes :
  #  k => v
  }
  target_group_arn = aws_lb_target_group.aws_node_lb_TG.arn
  target_id = each.value.id
}

resource "aws_lb_target_group_attachment" "public_TG_attachment" {
  for_each = {
    for k, v in aws_eks_node_group.public_nodes :
    k => v
  }  
  target_group_arn = aws_lb_target_group.aws_node_lb_TG_Public.arn
  target_id = each.key.id
}