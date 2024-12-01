data "aws_ssm_parameter" "amzn2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "wordpress_server" {
  ami                         = data.aws_ssm_parameter.amzn2.value
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.wordpress_server.id]
  key_name                    = "nginx-web-server-key"
  associate_public_ip_address = true

  tags = {
    Name = "${var.pj_name}-ec2"
  }

  # WordPress
  user_data = <<-EOF
                #!/bin/bash
                sudo sudo yum update -y
                sudo amazon-linux-extras install php7.4 -y
                sudo yum -y install mysql httpd php-mbstring php-xml

                wget http://ja.wordpress.org/latest-ja.tar.gz -P /tmp/
                tar zxvf /tmp/latest-ja.tar.gz -C /tmp
                sudo cp -r /tmp/wordpress/* /var/www/html/
                sudo chown apache:apache -R /var/www/html

                sudo systemctl enable httpd.service
                sudo systemctl start httpd.service
              EOF
}

resource "aws_security_group" "wordpress_server" {
  name        = "${var.pj_name}-wordpress-server-sg"
  description = "${var.pj_name} wordpress server sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.pj_name}-wordpress-server-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "wordpress_server" {
  count = length(var.security_group_ingress_rules)

  security_group_id = aws_security_group.wordpress_server.id
  cidr_ipv4         = var.security_group_ingress_rules[count.index].cidr
  ip_protocol       = "TCP"
  from_port         = var.security_group_ingress_rules[count.index].from_port
  to_port           = var.security_group_ingress_rules[count.index].to_port
}

resource "aws_vpc_security_group_egress_rule" "wordpress_server" {
  security_group_id = aws_security_group.wordpress_server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
