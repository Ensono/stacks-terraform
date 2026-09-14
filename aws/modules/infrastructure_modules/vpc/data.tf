# Current account ID
data "aws_caller_identity" "this" {}

data "aws_availability_zones" "available" {
  lifecycle {
    # Reject brownfield configs that pin Zone IDs which don't exist in the target region,
    # with a clear error instead of the cryptic index() failure in locals.sorted_azs_map.
    postcondition {
      condition = length(var.availability_zone_ids) == 0 || alltrue([
        for az in var.availability_zone_ids : contains(self.zone_ids, az)
      ])
      error_message = "Every availability_zone_ids entry must be a valid Zone ID in the target region. Valid Zone IDs: ${join(", ", self.zone_ids)}."
    }
  }
}
