provider "aws" {
  region     = "us-east-1"

}

resource "aws_instance" "webserver" {
  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.medium"
  key_name = aws_key_pair.eksctlkp.key_name
 vpc_security_group_ids = [aws_security_group.eksctl-sg.id]
associate_public_ip_address = true
  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = true
  }
 user_data = "${file("userdata.sh")}"
tags = {
    Name = "Eksctl"
  }
}