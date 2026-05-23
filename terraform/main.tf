module "network" {
  source = "./modules/network"
}

resource "aws_security_group" "web_sg" {
  name = "web-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.network.vpc_id

  tags = {
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
  }
}

resource "aws_instance" "web" {
  count         = 2
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  subnet_id              = module.network.public_subnets[count.index]
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name        = "web-${count.index}"
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "nimbuskart-logs"

  tags = {
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
#  bucket = aws_s3_bucket.logs.id

#  rule {
# id     = "expire-old-versions"
    #    status = "Enabled"

    #  filter {}

    #noncurrent_version_expiration {
    # noncurrent_days = 30
    #}
    #}
    #}

resource "aws_ebs_volume" "orphan_volume" {
  availability_zone = "us-east-1a"
  size              = 8

  tags = {
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
  }
}
