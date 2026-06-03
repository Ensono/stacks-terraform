module "ecr_repositories" {
  source = "../"

  region = "eu-west-2"

  repositories = ["foo", "bar"]

  pull_through_cache_setup = {
    ecr-public = {
      images                = ["image", "image2"]
      upstream_registry_url = "public.ecr.aws"
    }
    ecr-public-2 = {
      images                = ["image3", "image4"]
      upstream_registry_url = "public.ecr.aws"
    }
  }

  pull_accounts          = []
  pull_and_push_accounts = []

  max_tagged_image_count = 100

  enable_registry_scanning = true

  additional_lifecycle_rules = [
    {
      description = "Keep last 100 'main-*' tagged images"

      selection = {
        tagStatus     = "tagged"
        tagPrefixList = ["main-"]
        countType     = "imageCountMoreThan"
        countNumber   = 100
      }

      action = {
        type = "expire"
      }
    }
  ]

  tags = {}
}
