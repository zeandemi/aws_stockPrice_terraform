resource "aws_route53_record" "public_alb_route_record"{
 zone_id = aws_route53_zone.public_alb_zone.id
 name = "techbleat.bjordanlimited.co.uk"
 type = "A"
 ttl = 300
 alias {
    name = aws_lb.public_subnet_alb.dns_name
    zone_id = aws_lb.public_subnet_alb.zone_id
    evaluate_target_health = true
 }
}

resource "aws_route53_zone" "public_alb_zone" {
  name = "techbleat.bjordanlimited.co.uk"
}