locals {
  ami_id = "ami-08589eca6dcc9b39c"
}

resource "aws_instance" "master" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  key_name      = "default"
  user_data     = templatefile("${path.module}/user_data/master.sh.tmpl", {})
}

resource "aws_instance" "agent" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  key_name      = "default"
  user_data     = templatefile("${path.module}/user_data/agent.sh.tmpl", {})

  provisioner "puppet" {
    server      = aws_instance.master.public_dns
    connection {
      host        = self.public_ip
      private_key = file("${path.module}/keys/id_rsa")
    }
  }
}
