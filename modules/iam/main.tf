locals {
  admin_policy_name = coalesce(var.admin_policy_name, local.iam_role_name)

  arn_base      = join(":", slice(split(":", var.cluster_arn), 0, 5))
  iam_role_name = coalesce(var.iam_role_name, var.iam_role_name)
}
data "aws_iam_policy_document" "admin" {
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
      "arn:aws:eks:us-east-1:033848016404:cluster:nodegroup/*/*/*",
      "arn:aws:eks:us-east-1:033848016404:cluster:addon/*/*/*",
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
      "arn:aws:eks:us-east-1:033848016404:cluster:fargateprofile/*/*/*",
      "arn:aws:eks:us-east-1:033848016404:cluster:nodegroup/*/*/*",
      "arn:aws:eks:us-east-1:033848016404:cluster:addon/*/*/*",
    ]
  }
}

resource "aws_iam_policy" "admin" {
  name        = var.iam_role_use_name_prefix ? null : local.admin_policy_name
  name_prefix = var.iam_role_use_name_prefix ? "${local.admin_policy_name}-" : null
  path        = var.iam_role_path
  description = var.iam_role_description

  policy = data.aws_iam_policy_document.admin.json

  tags = var.tags
}

resource "aws_iam_role" "this" {
  name        = var.iam_role_use_name_prefix ? null : local.iam_role_name
  name_prefix = var.iam_role_use_name_prefix ? "${local.iam_role_name}-" : null
  path        = var.iam_role_path
  description = var.iam_role_description

  assume_role_policy    = data.aws_iam_policy_document.admin.json
  max_session_duration  = var.iam_role_max_session_duration
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "admin" {
  policy_arn = aws_iam_policy.admin.arn
  role       = aws_iam_role.this.name
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
