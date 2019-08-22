locals {
  ami_id = "ami-08589eca6dcc9b39c"
}

resource "aws_instance" "master" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  key_name      = "default"
  user_data     = file("${path.module}/user_data/master.sh")

  connection {
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("~/.ssh/default.pem")
  }

  provisioner "remote-exec" {
    on_failure = continue
    inline = [
      "sudo sh -c 'while ! grep -q Cloud-init.*finished /var/log/cloud-init-output.log; do sleep 60; done'"
    ]
  }
}

resource "aws_instance" "agent" {
  ami           = local.ami_id
  instance_type = "t2.micro"
  key_name      = "default"

  connection {
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("~/.ssh/default.pem")
  }

  provisioner "puppet" {
    use_sudo    = true
    server      = aws_instance.master.public_dns
    server_user = "ec2-user"
  }

  depends_on = [aws_instance.master]
}
