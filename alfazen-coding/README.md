# Alfazen Coding Skills

Reusable Agent Skills for software development, testing, git versioning, code review, and frontend engineering.

## Functional Area Matrix

| Area | Skills | Description |
|---|---|---|
| **Code Efficiency & Architecture** | [`ponytail`](ponytail/SKILL.md), [`alfazen-versioning`](alfazen-versioning/SKILL.md), [`handoff`](handoff/SKILL.md) | Anti-bloat Decision Ladder, Git patch bumps, and project checkpointing |
| **Engineering Methodology** | [`test-driven-development`](test-driven-development/SKILL.md), [`systematic-debugging`](systematic-debugging/SKILL.md), [`writing-plans`](writing-plans/SKILL.md), [`executing-plans`](executing-plans/SKILL.md), [`subagent-driven-development`](subagent-driven-development/SKILL.md), [`brainstorming`](brainstorming/SKILL.md) | Red-Green-Refactor TDD, root-cause isolation, plan execution, and subagent orchestration |
| **Quality & Review** | [`requesting-code-review`](requesting-code-review/SKILL.md), [`receiving-code-review`](receiving-code-review/SKILL.md), [`verification-before-completion`](verification-before-completion/SKILL.md) | Subagent review dispatch, technical feedback evaluation, and evidence checks |
| **Frontend, UX & Design** | [`ui-ux-pro-max`](ui-ux-pro-max/SKILL.md), [`impeccable`](impeccable/SKILL.md), [`apple-design`](apple-design/SKILL.md), [`figma`](figma/SKILL.md) | UI/UX intelligence database, design critique, Apple HIG review, and Figma token extraction |
| **Testing & Tooling** | [`playwright`](playwright/SKILL.md), [`github`](github/SKILL.md) | Headless browser testing, GitHub CLI automation, and CI/CD debugging |

## All Included Skills (18)

- **[`alfazen-versioning`](alfazen-versioning/SKILL.md)**: Bounded `m.n.p` versioning with per-commit patch bumps and `v{VERSION}-{BUILD}` UTC build IDs.
- **[`apple-design`](apple-design/SKILL.md)**: Cross-platform UI/UX design review and audit grounded in Apple Human Interface Guidelines.
- **[`brainstorming`](brainstorming/SKILL.md)**: Explore user intent, requirements, and design before implementation.
- **[`executing-plans`](executing-plans/SKILL.md)**: Execute written implementation plans with review checkpoints.
- **[`figma`](figma/SKILL.md)**: Figma REST API integration, design tokens, and SVG asset sync.
- **[`github`](github/SKILL.md)**: GitHub CLI workflows, PR management, and GitHub Actions CI/CD debugging.
- **[`handoff`](handoff/SKILL.md)**: Checkpoint `HANDOFF.md` for explicit milestone tracking and safe resumption.
- **[`impeccable`](impeccable/SKILL.md)**: Design critique, UI polish, visual hierarchy, and design system hardening.
- **[`playwright`](playwright/SKILL.md)**: Web application testing, UI verification, and screenshot capture.
- **[`ponytail`](ponytail/SKILL.md)**: Minimal, bloat-free coding via the Decision Ladder (YAGNI, stdlib first, anti-bloat).
- **[`receiving-code-review`](receiving-code-review/SKILL.md)**: Rigorous technical evaluation of review feedback.
- **[`requesting-code-review`](requesting-code-review/SKILL.md)**: Dispatches code reviewer subagents before completing tasks.
- **[`subagent-driven-development`](subagent-driven-development/SKILL.md)**: Subagent dispatch per task with isolated context and reviews.
- **[`systematic-debugging`](systematic-debugging/SKILL.md)**: Root-cause tracing before proposing fixes.
- **[`test-driven-development`](test-driven-development/SKILL.md)**: Red-green-refactor TDD workflow for features and fixes.
- **[`ui-ux-pro-max`](ui-ux-pro-max/SKILL.md)**: Searchable UI/UX design intelligence database and stack implementation rules.
- **[`verification-before-completion`](verification-before-completion/SKILL.md)**: Evidence-based verification before claiming completion.
- **[`writing-plans`](writing-plans/SKILL.md)**: Comprehensive, bite-sized implementation plan generation.

## Installation

### Option A: Natural Language Prompt (Ask Your AI Agent)

> *"Please install the `alfazen-coding` bundle skills from https://github.com/marcuz-apl/alfazen-skills.git"*

### Option B: Install All Coding Skills via `npx`

```sh
npx skills add https://github.com/marcuz-apl/alfazen-skills/tree/master/alfazen-coding -g -a claude-code -a codex -a gemini-cli --copy -y
```

### Option C: Install a Specific Skill via `npx`

```sh
npx skills add https://github.com/marcuz-apl/alfazen-skills/tree/master/alfazen-coding/test-driven-development -g -a claude-code -a codex -a gemini-cli --copy -y
```
