output "public_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}

output "vpc_id_details" {
  value = aws_vpc.demo-vpc-uc9.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "security_group_eks_cluster" {
  value = aws_security_group.eks_cluster.id
}