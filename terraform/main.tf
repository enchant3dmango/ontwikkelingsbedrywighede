module "s3_bucket" {
  source                  = "./modules/s3-bucket"
  aws_region              = var.aws_region
  s3_bucket_name          = var.s3_bucket_name
  s3_bucket_force_destroy = true
  prefix                  = "ob"
  suffix                  = "dev"
}
