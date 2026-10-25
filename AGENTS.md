# action-sqlfluff

GitHub Action (Docker + Shell) that runs [SQLFluff](https://github.com/sqlfluff/sqlfluff) with [reviewdog](https://github.com/reviewdog/reviewdog) for `lint` or `fix` on pull requests. Runtime is defined in `action.yml` (`runs.using: docker`, `image: Dockerfile`) and `entrypoint.sh`.

## When documentation and code disagree

When a repository's documentation and its existing code disagree, follow the conventions used in the existing code, and in your final reply point out each inconsistency you found between the documentation and the code.

"Documentation" includes this file, `CLAUDE.md`, editor rules, READMEs, `docs/`, ADRs, RFCs, and code comments. Treat what they say about the code as claims to check against the code, not as facts.

- **Documented target state wins only when it is explicit.** Follow the documentation instead of the code only when the documentation says the code is legacy or a migration is in progress. For example: a "migration in progress", "legacy", or "deprecated" marker, `@deprecated` on the code you would copy, or an ADR/RFC with status *Accepted* that is not superseded and is newer than the code it replaces. Ignore ADRs/RFCs that are *Proposed*, *Rejected*, *Deprecated*, or *Superseded*. Follow the superseding one.
- **When you can't tell which is current,** compare recency (`git log -1 --format=%cs -- <doc>` vs the code paths). Prefer the newer source, and say that you did. If the choice changes behavior and is still unclear, ask before proceeding.
- **Scope.** Apply the convention you choose to the code you are writing or changing. Don't rewrite working code, and don't edit documentation just to make the two agree, unless the task asks for it.
- **Process and safety rules still apply.** Commands to run, quality gates, review/merge rules, and security constraints in this file are not descriptions of the code. Follow them.
- **Report.** In your final reply (and in the PR description, if you open one), list each inconsistency: the document and section, what the code actually does, which one you followed, and why.

## Prerequisites

- Python `>=3.10` (`pyproject.toml`); the repo pins `3.13` (`.python-version`).
- [uv](https://github.com/astral-sh/uv) for local dev hooks (`Makefile`, `requirements.setup.txt`).

## Local development

| Task | Command | Source |
|------|---------|--------|
| Install SQLFluff 4.1.0 for dev + pre-commit hooks | `make setup-dev` | `Makefile` (`setup-dev`) |
| Lint (JSON fixture + pre-commit on all files) | `make lint` | `Makefile` (`lint`, `lint-json`, `run-pre-commit`) |
| Pre-commit only | `uv run pre-commit run --all-files` | `Makefile` (`run-pre-commit`) |
| Update hook revisions | `make update-pre-commit` | `Makefile` (`update-pre-commit`) |
| Build the action image locally | `make build-docker` | `Makefile` (`build-docker`) |

Pre-commit hooks (`end-of-file-fixer`, `trailing-whitespace`, `check-yaml`, `actionlint`, `hadolint-docker`) are listed in `.pre-commit-config.yaml`.

## CI (reference)

- **Test** (`.github/workflows/test.yml`): exercises the action against `testdata/test_failed_dbt` with matrixed SQLFluff versions and dialect configs; `paths-ignore: **/*.md`.
- **reviewdog** (`.github/workflows/reviewdog.yml`): `shellcheck`, `shfmt`, `actionlint`, `misspell`, and `alex` on pushes and pull requests.

## Repository layout

- `action.yml` — action metadata and inputs (defaults include `sqlfluff_version: "4.1.0"`, `reviewdog_version: "v0.21.0"`).
- `Dockerfile` — Python 3.13 image; installs reviewdog `v0.21.0` and runs `entrypoint.sh`.
- `docs/` — images only (`docs/images/`).
