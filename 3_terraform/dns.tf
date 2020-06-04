# Set some defaults for AWS like region.
#provider "aws" {
# profile = "default"
# region  = "eu-west-2"
#}


# Locate the correct zone from Route53

data "aws_route53_zone" "selected" {
  name         = "nginxdemo.net"
  private_zone = false
}


resource "aws_route53_record" "app-protect" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "app-protect.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "60"
# records = ["${chomp(http.myip.body)}"]
  records = [ aws_instance.nginx-app-protect-firewall.public_ip ]

}
