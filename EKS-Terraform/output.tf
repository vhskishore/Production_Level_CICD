output "cluster_id" {
    value = aws_eks_cluster.orghsk-eks.id
}

output "node_group_id" {
    value = aws_eks_node_group.orghsk-ng.id
}

output "vpc_id" {
    value = aws_vpc.orghsk_vpc.id
}

output "subnet_ids" {
    value = aws_subnet.orghsk_subnet[*].id
}