output "vpc" {
  value = aws_vpc.internal
}

output "public_subnet" {
  value = aws_subnet.public
}

output "private_subnet" {
  value = aws_subnet.private
}

output "route_table" {
  value = aws_route_table.private_rt
}

output "sg" {
  value = aws_security_group.allow_outbound
}

output "vpc_subnets_private_ids" {
  value = aws_subnet.private.*.id
}

output "vpc_subnets_private_id_1" {
  value = aws_subnet.private.0.id
}

output "vpc_subnets_private_id_2" {
  value = aws_subnet.private.1.id
}

output "vpc_subnets_private_id_3" {
  value = aws_subnet.private.2.id
}