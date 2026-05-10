---
paths:
  - "app/src/**/*.py"
  - "app/tests/**/*.py"
---

# Code

- All documentation, source code, variables, functions, and commits: **English**.
- **No secrets or passwords in code, env vars, logs, or `.tfvars`.** Use AWS Secrets Manager exclusively.
- **No floats or decimals for monetary values.** Always store as integers in cents. `12999` = R$ 129.99.
- **Naming (Python):** `snake_case` for variables, functions, and module-level attributes; `PascalCase` for classes; `UPPER_SNAKE_CASE` for module constants. JSON wire-format fields are governed by [api-design.md](api-design.md), not this rule.

## Logging

- Structured JSON logger — no plain string logs.
- **No PII in logs.** Never log email, CPF, or phone number.
