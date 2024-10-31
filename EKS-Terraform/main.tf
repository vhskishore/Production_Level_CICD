provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "orghsk_vpc" {
    cidr_block = "10.100.0.0/16"

    tags  = {
        Name = "orghsk-vpc"
    }
}

resource "aws_subnet" "orghsk_subnet" {
    count = 2
    vpc_id = aws_vpc.orghsk_vpc.id
    cidr_block = cidrsubnet(aws_vpc.hskorg_vpc.cidr_block, 8, count.index)
    availability_zone = element(["us-east-1a", "us-east-1b"], count.index)
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "orghsk_igw" {
    vpc_id = aws_vpc.orghsk_vpc.id

    tags = {
        Name = "orghsk-igw"
    }
}

resource "aws_route_table" "orghsk_rt" {
    vpc_id = aws_vpc.orghsk_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.orghsk-igw.id
    }

    tags = {
        Name = "orghsk-rt"
    }
}

resource "aws_route_table_association" "orghsk-rta" {
  count = 2
  subnet_id = aws_subnet.orghsk_subnet[count.index].id
  route_table_id = aws_route_table.orghsk_rt.id
}

resource "aws_security_group" "orghsk-cluster-sg" {
    vpc_id = aws_vpc.orghsk_vpc.id

    egress {
        from_port = 0
        to_port  = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "orghsk-cluster-sg"
    }
}

resource "aws_security_group" "orghsk-node-sg" {
    vpc_id = aws_vpc.orghsk_vpc.id

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "orghsk-node-sg"
    }
}

resource "aws_eks_cluster" "orghsk-eks" {
  name = "orghsk-cluster"
  role_arn = arn:aws:iam::850995565429:role/KOPS_ROLE

  vpc_config {
    subnet_ids = aws_subnet.orghsk_subnet[*].id
    security_group_ids = [aws_security_group.orghsk-cluster-sg.id]
  }
}

resource "aws_eks_node_group" "orghsk-ng" {
  cluster_name = aws_eks_cluster.orghsk-eks.name
  node_group_name = "orghsk-node-group"
  node_role_arn = arn:aws:iam::850995565429:role/KOPS_ROLE
  subnet_ids = aws_subnet.orghsk-subnet[*].id

  scaling_config {
    desired_size = 3
    max_size = 3
    min_size =3
  }

  instance_types = ["t2.medium"]

  remote_access {
    ec2_ssh_key = var.ssh_key_name
    source_security_group_ids = [aws_security_group.orghsk-node-sg.id]
  }

}

resource "aws_iam_role" "orghsk_cluster_role" {
  name = "orghsk-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "orghsk_cluster_role_policy" {
  role       = aws_iam_role.orghsk_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "orghsk_node_group_role" {
  name = "orghsk-node-group-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "orghsk_node_group_role_policy" {
  role       = aws_iam_role.orghsk_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "orghsk_node_group_cni_policy" {
  role       = aws_iam_role.orghsk_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "orghsk_node_group_registry_policy" {
  role       = aws_iam_role.orghsk_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}