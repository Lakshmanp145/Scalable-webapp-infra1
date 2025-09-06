resource "aws_instance" "bastion" {
  ami                    = "ami-09c813fb71547fc4f"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id              = local.public_subnet_id

  root_block_device {
    volume_size = 50  # Set root volume size to 50GB
    volume_type = "gp3"  # Use gp3 for better performance (optional)
  }
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project}-${var.environment}-bastion"
    }
  )

}

