resource "aws_instance" "Note-App" {
  count             = 3
  ami               = "ami-04a81a99f5ec58529"
  instance_type     = "t2.micro"
  key_name          = "vockey"
  security_groups = ["${aws_security_group.allow_ssh.name}"]

  tags = {
    Name = "Note-App-${count.index + 1}"
  }
}
