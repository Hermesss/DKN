
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
data "template_file" "init-db" {
  template = "${file("install-docker-ec2-aws-user-data-db.sh.tpl")}"

  vars = {
    POSTGRES_USER = "${var.POSTGRES_USER}"
    POSTGRES_DB = "${var.POSTGRES_DB}"
    POSTGRES_PASSWORD = "${var.POSTGRES_PASSWORD}"
  }
}

data "template_file" "init" {
  template = "${file("install-docker-ec2-aws-user-data.sh.tpl")}"

  vars = {
    db_address = "${aws_instance.dockerdb.private_ip}"
    POSTGRES_USER = "${var.POSTGRES_USER}"
    POSTGRES_DB = "${var.POSTGRES_DB}"
    POSTGRES_PASSWORD = "${var.POSTGRES_PASSWORD}"
    proxy1_ip = "${var.ips[0]}"
    proxy2_ip = "${var.ips[1]}"
  }
}
resource "aws_instance" "dockerdb" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "student10-1"
  vpc_security_group_ids = [aws_security_group.allow_inbound.id]
  subnet_id = "${aws_subnet.public.id}"
  user_data = "${data.template_file.init-db.rendered}"
  tags = {
    Name = "dockerdb"
  }
}

resource "aws_instance" "dockerweb" {
  count = 2
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "student10-1"
  private_ip = "${lookup(var.ips,count.index)}"
  vpc_security_group_ids = [aws_security_group.allow_inbound.id]
  subnet_id = "${aws_subnet.public.id}"
  user_data = "${data.template_file.init.rendered}"
  tags = {
    Name = "dockerweb"
  }
}