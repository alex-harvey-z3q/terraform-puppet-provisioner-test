variable "key_name" {
  description = "The name of the EC2 key pair to use"
  default     = "default"
}

variable "key_file" {
  description = "The private key for the ec2-user used in SSH connections and by Puppet Bolt"
  default     = "~/.ssh/default.pem"
}

locals {
  instance_type = "t2.micro"
}

data "aws_ami" "ami" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data/master.sh")
}

resource "aws_instance" "master" {
  ami           = data.aws_ami.ami.id
  instance_type = local.instance_type
  key_name      = var.key_name
  user_data     = data.template_file.user_data.rendered

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.key_file)
  }

  provisioner "remote-exec" {
    on_failure = continue
    inline = [
      "sudo sh -c 'while ! grep -q Cloud-init.*finished /var/log/cloud-init-output.log; do sleep 20; done'"
    ]
  }
}

resource "aws_instance" "agent" {
  ami           = data.aws_ami.ami.id
  instance_type = local.instance_type
  key_name      = var.key_name

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.key_file)
  }

  provisioner "puppet" {
    use_sudo    = true
    server      = aws_instance.master.public_dns
    server_user = "ec2-user"
  }

  depends_on = [aws_instance.master]
}
