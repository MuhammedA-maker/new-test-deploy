output "instance_ips" {
  description = "Public IP address of the EC2 instances"
  value= aws_instance.Note-App[*].public_ip
}