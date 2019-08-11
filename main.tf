resource "aws_instance" "example" {
  ami           = "ami-08589eca6dcc9b39c"
  instance_type = "t2.micro"
  key_name      = "default"
  user_data     = templatefile("${path.module}/user-data.sh.tmpl", {})
}
