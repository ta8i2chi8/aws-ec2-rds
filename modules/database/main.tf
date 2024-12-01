resource "aws_db_subnet_group" "wordpress_db" {
  name = "${var.pj_name}-db-subnet-group"
  subnet_ids = [
    var.private_1a_subnet_id,
    var.private_1c_subnet_id,
  ]

  tags = {
    Name = "${var.pj_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "wordpress_db" {
  identifier             = "wordpressdb"
  db_name                = "wordpress" # 最初のデータベース名
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.rds_username
  password               = var.rds_password
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.wordpress_db.name
  vpc_security_group_ids = [aws_security_group.wordpress_db.id]

  skip_final_snapshot = true

  tags = {
    Name = "${var.pj_name}-rds"
  }
}

resource "aws_security_group" "wordpress_db" {
  name        = "${var.pj_name}-wordpress-db-sg"
  description = "RDS security group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.pj_name}-wordpress-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "wordpress_db" {
  security_group_id            = aws_security_group.wordpress_db.id
  referenced_security_group_id = var.security_group_ingress_rules.referenced_security_group_id
  ip_protocol                  = "TCP"
  from_port                    = var.security_group_ingress_rules.from_port
  to_port                      = var.security_group_ingress_rules.to_port
}

resource "aws_vpc_security_group_egress_rule" "wordpress_db" {
  security_group_id = aws_security_group.wordpress_db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
