resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks_cluster"
  role_arn = aws_iam_role.EKSClusterRole.arn
  vpc_config {
    subnet_ids = [
      "${aws_subnet.public_Subnet[0].id}",
      "${aws_subnet.public_Subnet[1].id}",
      "${aws_subnet.public_Subnet[2].id}",
      "${aws_subnet.private_Subnet[0].id}",
      "${aws_subnet.private_Subnet[1].id}",
      "${aws_subnet.private_Subnet[2].id}"
    ]
    security_group_ids = [
      aws_security_group.private_node_group.id,
      aws_security_group.public_node_group.id
    ]
  }
  depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy]
}

resource "aws_eks_node_group" "private_nodes" {
  count           = length(local.subnets.public)
  cluster_name    = element(aws_eks_cluster.eks_cluster.*.id, count.index)
  subnet_ids      = ["${element(aws_subnet.private_Subnet.*.id, count.index)}"]
  node_group_name = "t3_medium-node_privategroup"
  node_role_arn   = aws_iam_role.NodeGroupRole.arn

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  ami_type       = "AL2_x86_64"
  instance_types = ["t3.medium"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  ]
}

resource "aws_eks_node_group" "public_nodes" {
  count           = length(local.subnets.public)
  cluster_name    = element(aws_eks_cluster.eks_cluster.*.id, count.index)
  subnet_ids      = ["${element(aws_subnet.public_Subnet.*.id, count.index)}"]
  node_group_name = "t3_medium-node_publicgroup"
  node_role_arn   = aws_iam_role.NodeGroupRole.arn

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  ami_type       = "AL2_x86_64"
  instance_types = ["t3.medium"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  ]
}

data "aws_eks_node_group" "public_node_group" {
  cluster_name = aws_eks_node_group.public_nodes.cluster_name
  node_group_name = aws_eks_node_group.public_nodes.node_group_name
}

data "aws_eks_node_group" "private_node_group" {
  cluster_name = aws_eks_node_group.private_nodes.cluster_name
  node_group_name = aws_eks_node_group.private_nodes.node_group_name
}