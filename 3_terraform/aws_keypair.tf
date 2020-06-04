resource "aws_key_pair" "app-protect" {
  key_name   = "app-protect-key"
  public_key = file ("~/.ssh/app-protect-key.pub")
}