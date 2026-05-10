# tpl-app-aws-lbd-python

Template repository for SthoreH AWS Lambda services written in Python.

Use **"Use this template" → "Create a new repository"** no GitHub para gerar um novo serviço a partir desse esqueleto. Depois siga o checklist abaixo.

Exemplo concreto deste template em uso: [`app-aws-lbd-products-service`](https://github.com/SthoreH/app-aws-lbd-products-service).

## Stack

- **Runtime:** Python 3.13
- **IaC:** Terraform 1.14.9, AWS Provider 6.40.0, region `sa-east-1`
- **CI/CD:** workflows reutilizáveis em [`shd-github-actions-workflows`](https://github.com/SthoreH/shd-github-actions-workflows) (pin atual: `@v1.4.4`)
- **Lambda module:** [`shd-terraform-aws-lambda`](https://github.com/SthoreH/shd-terraform-aws-lambda)
- **IAM module:** [`shd-terraform-aws-iam`](https://github.com/SthoreH/shd-terraform-aws-iam)

## Layout

- [app/src/](app/src/) — Lambda source code (`lambda_function.py`, `requirements.txt`).
- [app/tests/](app/tests/) — pytest suite.
- [terraform-aws/](terraform-aws/) — IaC (Lambda + IAM role + per-env tfvars).
- [.pipeline.yml](.pipeline.yml) — **single source of truth** para versões, paths e configuração por ambiente.
- [.github/workflows/](.github/workflows/) — caller workflows (CI, CD, rollback, destroy). Lógica vive nos workflows reusable.
- [.github/ISSUE_TEMPLATE/](.github/ISSUE_TEMPLATE/) — templates para abrir issue de rollback/destroy.
- [.github/rulesets/](.github/rulesets/) — regras de branch/tag protection (importar manualmente no GitHub).
- [.claude/](.claude/) — `CLAUDE.md` + `rules/` consumidos pelo Claude Code.

## Checklist de customização

Procure por `TODO` em todos os arquivos: `grep -rn "TODO" .`

1. **Renomear o repo** para `app-aws-lbd-<dominio>-<servico>` (ex.: `app-aws-lbd-orders-service`). Isso entra automaticamente em alguns lugares (rulesets, state key) por convenção do shd.
2. [`.claude/CLAUDE.md`](.claude/CLAUDE.md) — substituir nome do repositório e descrição na linha 1-3.
3. [`.pipeline.yml`](.pipeline.yml) — preencher `environments.dev.role-arn` e `environments.prod.role-arn` com os ARNs OIDC reais. Ajustar `files-to-replace` se usar token replacement.
4. [`terraform-aws/variables.tf`](terraform-aws/variables.tf) — atualizar `default` da `github_repository` para o nome real do repo.
5. [`terraform-aws/locals.tf`](terraform-aws/locals.tf) — definir `function_name`, `function_description`, `template_variables` e `environment_variables`.
6. [`terraform-aws/iam_templates/policies/application_policy.tftpl`](terraform-aws/iam_templates/policies/application_policy.tftpl) — começa vazio (`Statement: []`). Adicionar permissões reais. Ver exemplos em [`application_policy.example.tftpl`](terraform-aws/iam_templates/policies/application_policy.example.tftpl) (não consumido pelo Terraform — só referência).
7. [`terraform-aws/environments/dev.tfvars`](terraform-aws/environments/dev.tfvars) — env vars específicas de dev.
8. [`app/src/lambda_function.py`](app/src/lambda_function.py) — implementar handler real (atualmente faz echo do event).
9. [`app/src/requirements.txt`](app/src/requirements.txt) — adicionar dependências.
10. [`app/tests/test_handler.py`](app/tests/test_handler.py) — escrever testes reais; padrão `test_should_<expected>_when_<condition>`.
11. [`.github/workflows/*`](.github/workflows/) — pins padronizados em `@v1.4.4`. Confirmar se há versão mais nova em [`shd-github-actions-workflows`](https://github.com/SthoreH/shd-github-actions-workflows) e bumpar se necessário.

## Configuração no GitHub

Após customizar, no novo repo:

1. **GitHub Environments** — criar `dev` e `prod` em `Settings → Environments`. Em cada um, definir:
   - `vars.AWS_ROLE_ARN` — ARN da role OIDC para deploy (mesmo que está em `.pipeline.yml`).
   - `vars.TF_STATE_BUCKET` — bucket S3 do backend Terraform.
2. **Rulesets** — importar [`.github/rulesets/branches.ruleset.json`](.github/rulesets/branches.ruleset.json) e [`.github/rulesets/tags.ruleset.json`](.github/rulesets/tags.ruleset.json) em `Settings → Rules → Rulesets → New ruleset → Import a ruleset`.
3. **OIDC trust** — a role configurada em `AWS_ROLE_ARN` precisa aceitar OIDC do GitHub para esse repo. Provisionada via [`shd-aws-foundation`](https://github.com/SthoreH/shd-aws-foundation).
4. (Opcional) Habilitar **Template repository** em `Settings → General` se este repo for, ele próprio, servir de template para outros.

## Pipeline

- [ci-dev.yml](.github/workflows/ci-dev.yml), [ci-prod.yml](.github/workflows/ci-prod.yml) — PR validation (lint não-bloqueante, pytest, terraform fmt/validate/plan).
- [deploy-dev.yml](.github/workflows/deploy-dev.yml), [deploy-prod.yml](.github/workflows/deploy-prod.yml) — deploys em push para `dev`/`main`. `prod` adicionalmente roda semantic-release.
- [rollback.yml](.github/workflows/rollback.yml) — re-deploya numa tag anterior via issue rotulada.
- [destroy.yml](.github/workflows/destroy.yml) — destroi infra de `dev` via issue rotulada (prod só por CLI manual).

## Operações

**Rollback** — abrir issue com o [rollback request template](.github/ISSUE_TEMPLATE/rollback_request.yml) e aplicar o label `rollback-approved`.

**Destroy** — abrir issue com o [destroy request template](.github/ISSUE_TEMPLATE/destroy_request.yml) e aplicar o label `destroy-approved`. Restrito a `dev`.

## Verificação local pós-customização

```bash
# Lint TF + plan offline (sem credenciais)
cd terraform-aws && terraform init -backend=false && terraform validate

# Tests
cd app && pip install -r tests/test-requirements.txt && pytest tests

# Confirmar que sobraram só TODOs intencionais
grep -rn "TODO" . --exclude-dir=.git
```
