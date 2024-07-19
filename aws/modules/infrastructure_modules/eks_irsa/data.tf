data "aws_iam_policy" "additional_policies" {
  for_each = var.additional_policies

  name = each.value
}
