provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "cloudera-manger" {
  ami = "ami-af4333cf"
  instance_type = "m4.xlarge"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 100
  }
  key_name = "praseed-west-nc"
  tags {
    Name = "Cloudera-Manager"
    Owner = "praseed"
  }
  associate_public_ip_address = "true"
  security_groups = [ "sg-f71ab893" ] 
  subnet_id = "subnet-f2b1f3ab"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello Cloudera" > index.txt
              sed -i.bak -e 's,SELINUX=enforcing,SELINUX=disabled,' /etc/selinux/config	
              yum install wget
              reboot
              EOF
}

resource "aws_instance" "Worker" {
  ami = "ami-af4333cf"
  instance_type = "r4.xlarge"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 100
  }
  key_name = "praseed-west-nc"
  tags {
    Name = "worker"
    Owner = "praseed"
  }
  associate_public_ip_address = "true"
  security_groups = [ "sg-f71ab893" ] 
  subnet_id = "subnet-f2b1f3ab"
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
  ami = "ami-af4333cf"
  instance_type = "m4.4xlarge"

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

  key_name = "praseed-west-nc"
  tags {
    Name = "cdsw"
    Owner = "praseed"
  }
  associate_public_ip_address = "true"
  security_groups = [ "sg-f71ab893" ] 
  subnet_id = "subnet-f2b1f3ab"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello Cloudera" > index.txt
              sed -i.bak -e 's,SELINUX=enforcing,SELINUX=disabled,' /etc/selinux/config 
              yum install wget
              reboot
              EOF
}


