resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "DKN"
  }
}
resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public"
  }
}
resource "aws_security_group" "allow_inbound" {
  name        = "allow_inbound"
  description = "Allow inbound traffic from defined IPs and subnet"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    # SSH (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${var.access_ip}"]
  }
  ingress {
    # http (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["176.119.233.130/32"]
  }
  ingress {
    # postgeSQL (change to whatever ports you need)
    from_port = 5432
    to_port     = 5432
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${aws_subnet.public.cidr_block}"]
  }
  ingress {
    # proxy (change to whatever ports you need)
    from_port = 8081
    to_port     = 8082
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${aws_subnet.public.cidr_block}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Internet gateway
resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.main.id}"
}

## Default route to Internet

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gateway.id}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
  
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gateway.id}"
    }
}

# Associate subnet public_subnet to public route table
resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_vpc.main.main_route_table_id}"
}