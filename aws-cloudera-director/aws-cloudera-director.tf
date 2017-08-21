provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "cloudera-director" {
  ami = "ami-af4333cf"
  instance_type = "c4.large"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 10
    delete_on_termination = true
  }
  key_name = "praseed-west-nc"
  tags {
    Name = "Cloudera Director"
    Owner = "praseed"
  }
  associate_public_ip_address = "true"
  security_groups = [ "sg-f71ab893" ] 
  subnet_id = "subnet-f2b1f3ab"


  connection {
    user = "centos"
    private_key = "${file("/Users/praseed/praseed-west-nc.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install wget",
      "sudo wget -c --header \"Cookie: oraclelicense=accept-securebackup-cookie\" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm",
      "sudo rpm -ivh jdk-8u131-linux-x64.rpm",
      "cd /etc/yum.repos.d/",
      "sudo wget http://archive.cloudera.com/director/redhat/7/x86_64/director/cloudera-director.repo",
      "sudo yum -y install cloudera-director-server cloudera-director-client",
      "sudo service cloudera-director-server start",
      /*
      "sudo systemctl disable firewalld",
      "sudo systemctl stop firewalld",
      */

    ]
  }

/*
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello Cloudera" > index.txt
              yum install wget
              
              
              
              
              systemctl disable firewalld
              systemctl stop firewalld
              EOF
*/


}