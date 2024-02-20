resource "null_resource" "cis_bootstrap_validation" {
  lifecycle {
    precondition {
      condition     = (var.enable_cis_bootstrap == true && var.cis_bootstrap_image != "") || var.enable_cis_bootstrap == false
      error_message = "cis_bootstrap_image must be set if enable_cis_bootstrap is true"
    }
  }
}
