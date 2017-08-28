provider "aws" {
  region = "${var.AWS_DEFAULT_REGION}"
}


resource "aws_instance" "cloudera-manager" {
  ami = "${var.amis["us-west-1-centos_72"]}"
  instance_type = "${var.type["cloudera_manager"]}"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 100
  }
  key_name = "${var.ec2_keypair_name}"
  tags {
    Name = "Cloudera-Manager"
    Owner = "${var.owner_tag}"
  }
  associate_public_ip_address = "true"
  security_groups = ["${var.security_group}"]
  subnet_id = "${var.subnet_id}"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello Cloudera" > index.txt
              sed -i.bak -e 's,SELINUX=enforcing,SELINUX=disabled,' /etc/selinux/config	
              yum install wget
              reboot
              EOF
}

resource "aws_instance" "DataNode" {
  ami = "${var.amis["us-west-1-centos_72"]}"
  instance_type = "${var.type["datanode"]}"


  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 100
  }
  key_name = "${var.ec2_keypair_name}"
  tags {
    Name = "worker"
    Owner = "${var.owner_tag}"
  }
  associate_public_ip_address = "true"
  security_groups = ["${var.security_group}"]
  subnet_id = "${var.subnet_id}"

  count = 4

  user_data = <<-EOF
              #!/bin/bash
              sed -i.bak -e 's,SELINUX=enforcing,SELINUX=disabled,' /etc/selinux/config 
              echo "SELinux Disabled"
              yum install wget
              reboot
              EOF
}


resource "aws_instance" "cdsw" {
  ami = "${var.amis["us-west-1-rhel_72"]}"
  instance_type = "${var.type["cdsw_service"]}"


  root_block_device {
    volume_type = "gp2"
    volume_size = 100
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_type = "gp2"
    volume_size = 500
  }

  ebs_block_device{
      device_name = "/dev/sdg"
      volume_size = 1000
      volume_type = "io1"
      iops = 20000
    }

  key_name = "${var.ec2_keypair_name}"
  tags {
    Name = "cdsw"
    Owner = "${var.owner_tag}"
  }
  associate_public_ip_address = "true"
  security_groups = ["${var.security_group}"]
  subnet_id = "${var.subnet_id}"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello Cloudera" > index.txt
              sed -i.bak -e 's,SELINUX=enforcing,SELINUX=disabled,' /etc/selinux/config 
              yum install wget
              reboot
              EOF
}


