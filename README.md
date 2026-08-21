# Alfazen Skills

Reusable Agent Skills collection organized into specialized domain bundles for AI coding assistants and creative agents.

## Functional Area Matrix

| Area | Included Skills | Focus & Highlights |
|---|---|---|
| **Code Efficiency & Architecture** | [`ponytail`](./alfazen-coding/ponytail), [`alfazen-versioning`](./alfazen-coding/alfazen-versioning), [`handoff`](./alfazen-coding/handoff) | Anti-bloat Decision Ladder, connected VERSION-BUILD identifiers, and project checkpoints |
| **Engineering Methodology** | [`test-driven-development`](./alfazen-coding/test-driven-development), [`systematic-debugging`](./alfazen-coding/systematic-debugging), [`writing-plans`](./alfazen-coding/writing-plans), [`executing-plans`](./alfazen-coding/executing-plans), [`subagent-driven-development`](./alfazen-coding/subagent-driven-development), [`brainstorming`](./alfazen-coding/brainstorming) | Red-Green-Refactor TDD, root-cause isolation, plan execution, and subagent orchestration |
| **Quality & Review** | [`requesting-code-review`](./alfazen-coding/requesting-code-review), [`receiving-code-review`](./alfazen-coding/receiving-code-review), [`verification-before-completion`](./alfazen-coding/verification-before-completion) | Subagent review dispatch, technical feedback verification, and evidence checks |
| **Frontend, UX & Design** | [`ui-ux-pro-max`](./alfazen-coding/ui-ux-pro-max), [`impeccable`](./alfazen-coding/impeccable), [`figma`](./alfazen-coding/figma) | UI/UX intelligence database, design critique, visual polish, and Figma token extraction |
| **Testing & Tooling** | [`playwright`](./alfazen-coding/playwright), [`github`](./alfazen-coding/github) | Headless browser testing, GitHub CLI automation, and CI/CD Actions debugging |
| **Generative Media** | [`character`](./alfazen-media/character), [`hyperframes`](./alfazen-media/hyperframes), [`remotion`](./alfazen-media/remotion), [`sequence`](./alfazen-media/sequence) | Programmatic React video, motion shaders, character design, and scene sequencing |

---

## Skill Bundles

### 1. [`alfazen-coding`](./alfazen-coding) (17 Skills)

Workflows for software engineering, testing, git versioning, code reviews, and UI/UX design:

| Skill | Description |
|---|---|
| [`alfazen-versioning`](./alfazen-coding/alfazen-versioning) | Bounded `m.n.p` VERSION numbers connected to UTC `yymmddc` BUILD numbers |
| [`brainstorming`](./alfazen-coding/brainstorming) | Explores intent, requirements, and design before creative or implementation work |
| [`executing-plans`](./alfazen-coding/executing-plans) | Executes implementation plans in separate sessions with review checkpoints |
| [`figma`](./alfazen-coding/figma) | Figma REST API integration, design tokens, and SVG asset synchronization |
| [`github`](./alfazen-coding/github) | GitHub CLI workflows, PR management, and GitHub Actions CI/CD debugging |
| [`handoff`](./alfazen-coding/handoff) | Root `HANDOFF.md` for explicit checkpoints, milestones, and safe resumption |
| [`impeccable`](./alfazen-coding/impeccable) | Comprehensive design critique, UX/UI polish, styling, and design systems |
| [`playwright`](./alfazen-coding/playwright) | Web application testing, UI verification, screenshot capture, and logs |
| [`ponytail`](./alfazen-coding/ponytail) | Minimal, bloat-free coding via the Decision Ladder (YAGNI, stdlib first, anti-bloat) |
| [`receiving-code-review`](./alfazen-coding/receiving-code-review) | Rigorous technical evaluation and verification of code review feedback |
| [`requesting-code-review`](./alfazen-coding/requesting-code-review) | Dispatches code reviewer subagents to verify implementation before merging |
| [`subagent-driven-development`](./alfazen-coding/subagent-driven-development) | Subagent dispatch per task with isolated context and iterative reviews |
| [`systematic-debugging`](./alfazen-coding/systematic-debugging) | Root-cause tracing and systematic debugging before proposing fixes |
| [`test-driven-development`](./alfazen-coding/test-driven-development) | Red-Green-Refactor TDD workflow for features and bugfixes |
| [`ui-ux-pro-max`](./alfazen-coding/ui-ux-pro-max) | Searchable UI/UX intelligence database (styles, palettes, fonts, UX guidelines) |
| [`verification-before-completion`](./alfazen-coding/verification-before-completion) | Evidence-based command and test verification before claiming completion |
| [`writing-plans`](./alfazen-coding/writing-plans) | Comprehensive implementation plan creation with explicit file changes |

### 2. [`alfazen-media`](./alfazen-media) (4 Skills)

Workflows for generative media, animation, video programming, character design, and timeline sequencing:

| Skill | Description |
|---|---|
| [`character`](./alfazen-media/character) | Persona design, turnarounds, expression sheets, and multi-shot style consistency |
| [`hyperframes`](./alfazen-media/hyperframes) | Generative motion graphics, WebGL shaders, and canvas frame keyframing |
| [`remotion`](./alfazen-media/remotion) | Programmatic React video creation, composition, and rendering pipelines |
| [`sequence`](./alfazen-media/sequence) | Storyboarding, camera framing, pacing rhythm, and scene orchestration |

---

## Installation

### Option A: Natural Language Prompt (Ask Your AI Agent)

You can simply instruct your AI coding assistant (Antigravity, Claude Code, Cursor, Codex, Gemini CLI):

> *"Please install the `alfazen-coding` bundle skills from https://github.com/marcuz-apl/alfazen-skills.git"*

or for media workflows:

> *"Please install the `alfazen-media` bundle skills from https://github.com/marcuz-apl/alfazen-skills.git"*

The agent will read the repository structure and install or link the skills into your agent environment.

### Option B: Install an Entire Skill Bundle via `npx`

Install all skills in a bundle across agents (Claude Code, Codex, Gemini CLI, Cursor):

```sh
# Install all coding skills
npx skills add https://github.com/marcuz-apl/alfazen-skills/tree/master/alfazen-coding -g -a claude-code -a codex -a gemini-cli --copy -y

# Install all media skills
npx skills add https://github.com/marcuz-apl/alfazen-skills/tree/master/alfazen-media -g -a claude-code -a codex -a gemini-cli --copy -y
```

### Option C: Install a Specific Skill via `npx`

```sh
# Install only test-driven-development
npx skills add https://github.com/marcuz-apl/alfazen-skills/tree/master/alfazen-coding/test-driven-development -g -a claude-code -a codex -a gemini-cli --copy -y

# Install only remotion
npx skills add https://github.com/marcuz-apl/alfazen-skills/tree/master/alfazen-media/remotion -g -a claude-code -a codex -a gemini-cli --copy -y
```

### Option D: Manual or Local Link Installation

Copy or symlink any skill directory into your personal agent skill directory:

| Runtime | Personal skill directory |
|---|---|
| Codex | `~/.codex/skills/<skill-name>` or `~/.agents/skills/<skill-name>` |
| Claude Code | `~/.claude/skills/<skill-name>` |
| Gemini CLI | `~/.gemini/skills/<skill-name>` or `~/.agents/skills/<skill-name>` |

For Gemini CLI, you can link directly from your local clone:

```sh
gemini skills link ./alfazen-coding/alfazen-versioning --scope user
```

---

## Acknowledgements & Upstream Sources

This repository curates and packages agent skills from the open-source community and original internal creations:

- **[Alfazen Inc.](https://alfazen.org)**:
  - `alfazen-versioning` — Bounded `m.n.p` VERSION numbers connected to UTC `yymmddc` BUILD numbers.
  - `handoff` — Checkpoint and safe project resumption skill (product of Alfazen Inc.).
- **[Remotion Skills](https://github.com/remotion-dev/skills)** by Remotion Team:
  - `remotion` — Programmatic React video creation, composition, and rendering pipelines.
- **[HyperFrames](https://github.com/heygen-com/hyperframes)** by HeyGen / HyperFrames Team:
  - `hyperframes` — Generative motion graphics, WebGL shaders, and canvas frame keyframing.
- **Unknown Geeks & Community Creators**:
  - `character` — Persona design, turnarounds, expression sheets, and multi-shot consistency.
  - `sequence` — Storyboarding, camera framing, pacing rhythm, and scene orchestration.
- **[Superpowers Framework](https://github.com/obra/superpowers)** by Jesse Vincent / Prime Radiant:
  - `brainstorming`, `writing-plans`, `executing-plans`, `subagent-driven-development`, `systematic-debugging`, `test-driven-development`, `requesting-code-review`, `receiving-code-review`, `verification-before-completion`
- **[Ponytail](https://github.com/DietrichGebert/ponytail)** by Dietrich Gebert:
  - `ponytail` — minimal, bloat-free coding via the Decision Ladder (YAGNI, stdlib first, anti-bloat)
- **[Impeccable](https://github.com/pbakaus/impeccable)** by Paul Bakaus:
  - `impeccable` — frontend craft, design systems, visual polish, and UX guidance
- **[UI/UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill)**:
  - `ui-ux-pro-max` — searchable UI/UX design intelligence database and stack implementation rules
- **Anthropic Skill Packages**:
  - `playwright` (Web Application Testing) — licensed under Apache 2.0 (Copyright Anthropic, PBC)
- **Developer Workflows & Tooling**:
  - `github` — GitHub CLI workflows, PR management, and GitHub Actions CI/CD debugging
  - `figma` — Figma REST API integration, design token extraction, and SVG synchronization

## License

This skill collection is released under the [MIT License](LICENSE). It is free to use, copy, modify, redistribute, and include in commercial projects, subject to the copyright and license notice. Included third-party skills retain their respective original licenses and copyright notices (e.g., Apache 2.0 for `playwright`).
