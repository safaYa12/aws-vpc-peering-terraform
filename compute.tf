# Find Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]
    
    filter {
      name = "name"
      values = ["al2023-ami-2023.*-x86_64"]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
}

# Primary EC2
resource "aws_instance" "primary" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.primary.id
    vpc_security_group_ids = [aws_security_group.primary.id]
    key_name = var.key_name1
    associate_public_ip_address = true

    user_data = <<-EOF
        #!bin/bash
        dnf install -y httpd
        systemctl enable --now httpd
        echo "Hello From Primary VPC 10.0.0.0/16" > /var/www/html/index.html 
    EOF
    tags = {
        Name = "Primary-EC2"
    }
  
}
# Secondary EC2
resource "aws_instance" "secondary" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t3.micro"
    subnet_id = aws_subnet.secondary.id
    vpc_security_group_ids = [aws_security_group.secondary.id]
    key_name = var.key_name2
    associate_public_ip_address = true

    user_data = <<-EOF
        #!/bin/bash
        dnf install -y httpd
        systemctl enable --now httpd
        echo "Hello From Secondary VPC 10.1.0.0/16" > /var/www/html/index.html
    EOF
    tags = {
        Name = "Secondary-EC2"
    }
  
}

  
