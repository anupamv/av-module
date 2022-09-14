provider "aws" {
  region = "ap-southeast-1"
}

locals {

  env = terraform.workspace

  counts = {
    "default" = 1
    "prod"    = 3
    "dev"     = 2
  }


  tags = {
    "default" = "webserver-def"
    "prod"    = "webserver-prod"
    "dev"     = "webserver-dev"
  }



  count = lookup(local.counts, local.env)
  mytag = lookup(local.tags, local.env)

}


resource "aws_instance" "ec2-instance" {
  #    ami = "ami-041d6256ed0f2061c"    # this AMI is specific to Mumbai region
  ami = var.ami_id # referring to ami_id variable
  #    instance_type = "t2.micro"
  instance_type = var.instance_type # referring to instance_type variable
  count         = local.count
  tags = {
    Name = "${local.mytag}"
  }
  
}



#Create two workspaces - dev and prod
#terraform workspace new dev
#terraform workspace new prod

#Switch to a workspace
#terraform workspace select <workspace-name>

#List all workspaces
#terraform workspace list

#Delete a workspace
#terraform workspace delete <workspace-name>
#
#The advantage of using locals instead of variables is that locals can have
#logic inside them, instead of in the resource. Whereas variables only allows
#values and push the logic inside the resource.
