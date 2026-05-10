# Repo: <TODO: nome do repositório, ex.: app-aws-lbd-orders-service>

<TODO: descrição em uma linha do que esse Lambda faz>

## Layout

- [app/src/](../app/src/) — Lambda source.
- [app/tests/](../app/tests/) — pytest suite.
- [terraform-aws/](../terraform-aws/) — IaC (Lambda, IAM role).
- [.pipeline.yml](../.pipeline.yml) — pipeline configuration consumed by the shared workflows. **Single source of truth** for runtime versions, terraform version, paths, and per-env values. Do not hardcode any of these in workflows or rules.
- [.github/workflows/](../.github/workflows/) — caller workflows. Thin wrappers; logic lives upstream.

## Pipeline is delegated

CI/CD lives in [shd-github-actions-workflows](../../../shd/shd-github-actions-workflows/). Caller workflows here only invoke reusable workflows or composite actions there. **If a step needs to change, change it in shd and bump the pin.** Do not inline pipeline logic locally.

Current pin: `@v1.4.4`.

## Granular rules

Topic-specific guidance lives in [.claude/rules/](rules/) — terraform, coding, api-design, testing. Read those before touching the matching paths.
