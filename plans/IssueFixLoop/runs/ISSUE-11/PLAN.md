# PLAN: Resolve Documentation Linting Violations

## Objective

Fix priority markdown linting violations across the repository to improve consistency and maintainability.

## Strategy

1. **Manual Remediation**: Fix specific files mentioned in the issue or high-level project docs.
2. **Automated Cleanup**: Use shell scripts/regex to fix widespread boilerplate issues in the `agent/` directory.
3. **Template Updates**: Ensure project templates are lint-clean to prevent future regressions.

## Tasks

1. [x] Fix `MILESTONE_PLAN.md` duplicate headings and line wrapping.
2. [x] Align table pipes in `TEST_STATE.md`.
3. [x] Fix `PR_CORE_REFACTOR.md` emphasis-as-heading.
4. [x] Fix boilerplate headers/lists in `agent/` subfolders via script.
5. [x] Fix duplicate headings in `PULL_REQUEST_TEMPLATE.md` and `github_rules.md`.
6. [x] Deduplicate headings in `GITHUB_ISSUES_EXPORT.md`.
7. [x] Add missing code block languages in `github_rules.md`.

## Verification

- Run `markdownlint-cli` on modified files.
- Ensure priority rules (MD024, MD060, MD036) pass for targeted files.
