provider "aws" {
  region = "us-east-1" 
}

resource "aws_instance" "ansible_server" {
  ami           = "ami-04505e74c0741db8d" 
  instance_type = "t2.micro"              
  count         = 2                       

  key_name      = "ansible1"              

  #user_data
  user_data = file("user_data.sh")

  tags = {
    Name = "ubuntu-server-${count.index + 1}"
  }
}
