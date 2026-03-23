resource "aws_instance" "server" {
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t3.micro"
  
  # Change 'security_groups' to 'vpc_security_group_ids'
  vpc_security_group_ids = [aws_security_group.sg.id] 
  
  user_data = <<-EOF
                #!/bin/bash
                dnf update -y
                dnf install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "<h1>Hello, this is the Testing Page</h1>" > /var/www/html/index.html
                EOF
  
  tags = {
    Name = "Web Server"
  }
}

data "aws_vpc" "default" {
  default = true
} 

resource "aws_security_group" "sg" {
    name = "web_sg"
    vpc_id = data.aws_vpc.default.id

   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
}

