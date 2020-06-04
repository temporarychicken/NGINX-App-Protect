

# Fetch AWS NGINX App Protect AMI identifier
data "aws_ami" "nginx-app-protect" {
  most_recent = true
  owners      = ["self"]
  filter {
    name = "tag:Name"
    values = [
      "nginx-app-protect",
    ]
  }
}
