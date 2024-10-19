resource "aws_instance" "Note-App" {
  ami               = "ami-0866a3c8686eaeeba"
  instance_type     = "t2.micro"
  key_name          = "my-key"
  security_groups = ["${aws_security_group.allow_ssh.name}"]
}
