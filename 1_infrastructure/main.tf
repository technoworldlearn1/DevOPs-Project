

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"

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
    Name = "allow_web_traffic"
  }
}

# Creating Ec2 instance with user data

resource "aws_instance" "app_server" {
  ami           = "ami-0c02fb55956c7d316" # Change this to a valid AMI in your region
  instance_type = "t2.micro"
  key_name      = "your-key-pair-name" # Add your key pair 
  security_groups = aws_security_group.allow_web.name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y java-1.8.0-openjdk
              wget https://your-java-app-bucket.s3.amazonaws.com/your-java-app.jar -O /home/ec2-user/your-java-app.jar
              java -jar /home/ec2-user/your-java-app.jar
              EOF

  tags = {
    Name = "Java App Server"
  }
}
