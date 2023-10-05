variable "create_iam_role" {
  description = "Determines whether an IAM role is created or to use an existing IAM role"
  type        = bool
  default     = true
}

variable "iam_role_arn" {
  description = "Existing IAM role ARN for the node group. Required if `create_iam_role` is set to `false`"
  type        = string
  default     = null
}

variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`iam_role_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "iam_role_max_session_duration" {
  description = "Maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours"
  type        = number
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "iam_role_policies" {
  description = "IAM policies to be added to the IAM role created"
  type        = map(string)
  default     = {}
}

# IRSA
variable "users" {
  description = "A list of IAM user and/or role ARNs that can assume the IAM role created"
  type        = list(string)
  default     = []
}

variable "principal_arns" {
  description = "A list of IAM principal arns to support passing wildcards for AWS Identity Center (SSO) roles. [Reference](https://docs.aws.amazon.com/singlesignon/latest/userguide/referencingpermissionsets.html#custom-trust-policy-example)"
  type        = list(string)
  default     = []
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider created by the EKS cluster"
  type        = string
  default     = ""
}

variable "enable_admin" {
  description = "Determines whether an IAM role policy is created to grant admin access to the Kubernetes cluster"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all AWS resources"
  type        = map(string)
  default     = {}
}