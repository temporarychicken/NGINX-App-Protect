resource "aws_instance" "nginx-app-protect-firewall" {
  ami                         = data.aws_ami.nginx-app-protect.id # eu-west-2
  instance_type               = "t2.medium"
  key_name                    = "app-protect-key"
  security_groups             = [aws_security_group.nginx-web-facing.id]
  subnet_id                   = aws_subnet.main.id
  private_ip                  = "10.0.1.100"
  
  tags = {
    Name = "nginx-app-protect-firewall"
  }

  
  
  
}

