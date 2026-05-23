resource "aws_vpc" "main" {
  cidr_block = "10.20.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.20.${count.index}.0/24"
  availability_zone       = "us-east-1${count.index == 0 ? "a" : "b"}"
  map_public_ip_on_launch = true
}
