data "aws_caller_identity" "current" {}

# Public AWS-managed SSM parameter that always points to the latest Powertools layer ARN
# for the given architecture and Python runtime. See:
# https://docs.powertools.aws.dev/lambda/python/latest/#sar-ssm
data "aws_ssm_parameter" "powertools_layer_arn" {
  name = "/aws/service/powertools/python/${local.powertools_layer_arch}/${local.runtime}/latest"
}
