output "instance_1_id" {
  value = module.ec2_instance["1"].id
}

output "instance_2_id" {
  value = module.ec2_instance["2"].id
}
