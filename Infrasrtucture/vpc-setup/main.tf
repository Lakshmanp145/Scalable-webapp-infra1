module "vpc" {
    source = "git::https://github.com/Lakshmanp145/vpc-module.git?ref=main"
    project = var.project
    environment = var.environment
    common_tags = var.common_tags
    cidr_block = var.cidr_block
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    is_peering_required = var.is_peering_required

}

# this can be included in module
resource "aws_db_subnet_group" "expense" {
  name       = "${var.project}-${var.environment}"
  subnet_ids = module.vpc.database_subnet_ids

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project}-${var.environment}"
    }
  )
}
