locals {
  # TODO: prefixo do produto (ex.: "biji"). Define a permissions boundary que o
  # módulo de IAM anexa à role: <product>-SharedPolicyBoundary. A role de deploy
  # só tem iam:CreateRole sob a condição de a boundary do produto estar presente,
  # então um valor errado aqui faz o apply falhar com AccessDenied.
  product = "example"

  # TODO: nome curto da função Lambda (kebab-case). Convenção SthoreH: lbd-<dominio>-<servico>
  function_name = "lbd-example-service"
  # TODO: descrição humana da função
  function_description = "Example Lambda function"
  handler              = "lambda_function.lambda_handler"
  runtime              = "python3.13"

  function_alias = var.environment

  # Convention: the CI/CD pipeline packages the Lambda to <repo-root>/dist/lambda.zip
  # before terraform plan/apply. Keeping the path here avoids passing -var from workflows.
  lambda_zip_path = "${path.root}/../dist/lambda.zip"

  environment_variables = {
    ENVIRONMENT = var.environment
    # TODO: adicione env vars derivadas (ex.: TABLE_NAME = "myservice-${var.environment}")
  }

  # TODO: variáveis usadas pelos templates IAM em iam_templates/**.
  # account_id já é fornecido. Adicione campos conforme suas policies precisarem
  # (ex.: table_name, queue_name, bucket_name).
  template_variables = {
    account_id = data.aws_caller_identity.current.account_id
  }

  architectures = ["arm64"] # TODO: escolha a arquitetura (ex.: ["x86_64"] ou ["arm64"]). Lembre-se de atualizar o handler e as dependências locais se necessário.
  # Powertools layer ARN is resolved from a public AWS-managed SSM parameter (see data.tf),
  # so the latest version is picked up automatically without bumping a hardcoded layer version.
  powertools_layer_arch = local.architectures[0]

  layers = [
    data.aws_ssm_parameter.powertools_layer_arn.value
  ]

  tags = {
    ManagedBy  = "terraform"
    Repository = "github.com/${var.organization}/${var.github_repository}"
  }
}
