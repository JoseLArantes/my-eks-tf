locals {
  admin_policy_name = coalesce(var.admin_policy_name, local.iam_role_name)

  arn_base = join(":", slice(split(":", var.cluster_arn), 0, 5))
}

data "aws_iam_policy_document" "admin" {
  count = var.create_iam_role && var.enable_admin ? 1 : 0

  statement {
    sid = "List"
    actions = [
      "eks:ListFargateProfiles",
      "eks:ListNodegroups",
      "eks:ListUpdates",
      "eks:ListAddons"
    ]
    resources = [
      var.cluster_arn,
      "${local.arn_base}:nodegroup/*/*/*",
      "${local.arn_base}:addon/*/*/*",
    ]
  }

  statement {
    sid = "ListDescribeAll"
    actions = [
      "eks:DescribeAddonConfiguration",
      "eks:DescribeAddonVersions",
      "eks:ListClusters",
    ]
    resources = ["*"]
  }

  statement {
    sid = "Describe"
    actions = [
      "eks:DescribeNodegroup",
      "eks:DescribeFargateProfile",
      "eks:ListTagsForResource",
      "eks:DescribeUpdate",
      "eks:AccessKubernetesApi",
      "eks:DescribeCluster",
      "eks:DescribeAddon"
    ]
    resources = [
      var.cluster_arn,
      "${local.arn_base}:fargateprofile/*/*/*",
      "${local.arn_base}:nodegroup/*/*/*",
      "${local.arn_base}:addon/*/*/*",
    ]
  }
}

resource "aws_iam_policy" "admin" {
  count = var.create_iam_role && var.enable_admin ? 1 : 0

  name        = var.iam_role_use_name_prefix ? null : local.admin_policy_name
  name_prefix = var.iam_role_use_name_prefix ? "${local.admin_policy_name}-" : null
  path        = var.iam_role_path
  description = var.iam_role_description

  policy = data.aws_iam_policy_document.admin[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "admin" {
  count = var.create_iam_role && var.enable_admin ? 1 : 0

  policy_arn = aws_iam_policy.admin[0].arn
  role       = aws_iam_role.this[0].name
}

variable "admin_policy_name" {
  description = "Name to use on admin IAM policy created"
  type        = string
  default     = ""
}

variable "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  type        = string
  default     = ""
}
