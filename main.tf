data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"]
}

output "test" {
  value = data.aws_ami.ubuntu
}

resource "aws_security_group" "security_group" {
  name = "sec_group_github_runner"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my-instance" {
  vpc_security_group_ids = [aws_security_group.security_group.id]
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro" ## Free tier
  user_data = templatefile("scripts/ec2.sh", {personal_access_token = var.personal_access_token})
	tags = {
		Name = "GitHub-Runner"	
		Type = "terraform"
	}
}
