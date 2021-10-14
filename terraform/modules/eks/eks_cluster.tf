
resource "aws_eks_cluster" "demo" {
  name     = "demoapp-cluster"
  role_arn = aws_iam_role.demo.arn

  vpc_config {
    subnet_ids = var.private_subnets
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.eksregistry,
    aws_iam_role_policy_attachment.eksnodes
  ]
}

resource "aws_iam_role" "demo" {
  name = "eks-cluster-example"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["eks.amazonaws.com","ec2.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo.name
}


resource "aws_iam_role_policy_attachment" "demo-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.demo.name
}

resource "aws_iam_role_policy_attachment" "eksregistry" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.demo.name
}

resource "aws_iam_role_policy_attachment" "eksnodes" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.demo.name
}
output "endpoint" {
  value = aws_eks_cluster.demo.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.demo.certificate_authority[0].data
}