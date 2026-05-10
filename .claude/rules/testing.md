---
paths:
  - "app/tests/**/*.py"
---

# Testing Rules

- Framework: **pytest** (matches what the pipeline runs and what is pinned in [test-requirements.txt](../../app/tests/test-requirements.txt)).
- Use descriptive test names: `test_should_<expected>_when_<condition>`.
- Mock external dependencies (AWS, HTTP, etc.) — not internal modules. Use `moto` for AWS mocks; `pytest-mock` for general mocking.
- Clean up side effects with pytest fixtures using `yield` for teardown.
