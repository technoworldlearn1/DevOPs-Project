
# creating a custom VPC 

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"  # a sample CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true

tags = {
    Name = "MyVPC"
  }
}

# creating two subnets: subnet1, subnet2 under the custom VPC 

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"  # sample CIDR block
  availability_zone = "us-east-1a"   # desired availability zone

   tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"  # sample CIDR block
  availability_zone = "us-east-1b"   # desired availability zone

   tags = {
    Name = "subnet-2"
  }
}


# creating elastic loadbalancer 

resource "aws_elb" "example" {
  name               = "example-elb"
  availability_zones = ["us-east-1a", "us-east-1b"]  
    listener {
    instance_port     = 8080
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:8080/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


# creating aws autoscaling group

resource "aws_autoscaling_group" "example" {
  availability_zones  = ["us-east-1a", "us-east-1b"]  
  desired_capacity    = 2
  min_size            = 1
  max_size            = 10
  launch_configuration = aws_launch_configuration.example.id
}


# creating a security group 

resource "aws_security_group" "allow_http" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-group"
  }

}

# launching an autoscaling template 

resource "aws_launch_configuration" "example" {
  image_id        = "ami-12345678"  # AMI ID
  instance_type   = "t2.micro"      # instance type
  security_groups = [aws_security_group.allow_http.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y java-1.8.0-openjdk
              wget https://your-java-app-bucket.s3.amazonaws.com/your-java-app.jar -O /home/ec2-user/your-java-app.jar
              java -jar /home/ec2-user/your-java-app.jar
              EOF

  tags = {
    Name = "Java App Server1"
  }            
}

# creating route53 

resource "aws_route53_zone" "example" {
  name = "example.com"
}

resource "aws_route53_record" "example" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "example.com"
  type    = "A"
  ttl     = "300"
  records = [aws_elb.example.dns_name]
}




