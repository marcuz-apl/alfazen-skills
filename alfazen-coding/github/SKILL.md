---
name: github
description: "GitHub CLI workflows, pull request creation and management, issue tracking, CI/CD GitHub Actions debugging, and automated repository release workflows."
---

# GitHub Skill

Procedures and best practices for automating GitHub repository workflows using the GitHub CLI (`gh`), Git, and GitHub Actions.

## Key Capabilities

### 1. Pull Request Management
- Create PRs with clean titles and descriptive summaries:
  ```bash
  gh pr create --title "feat: descriptive title" --body "## Summary..."
  ```
- View PR review comments, CI checks, and merge statuses:
  ```bash
  gh pr status
  gh pr checks
  gh pr view <pr-number> --comments
  ```

### 2. Issue Tracking
- List, view, and create issues:
  ```bash
  gh issue list --state open
  gh issue view <issue-number>
  gh issue create --title "..." --body "..."
  ```

### 3. GitHub Actions CI/CD Diagnostics
- Inspect workflow runs and diagnose job failures:
  ```bash
  gh run list --limit 5
  gh run view <run-id> --log-failed
  ```

### 4. Release & Tag Management
- Create releases and upload build assets:
  ```bash
  gh release create v1.0.0 --title "v1.0.0" --notes "Release notes"
  ```
