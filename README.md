# Alfazen Skills

Reusable Agent Skills for Git and development workflows.

## Included skills

### `alfazen-versioning`

Configures or audits bounded `m.n.p` Git versioning with:

- a tracked root `VERSION` file;
- automatic per-commit patch bumps;
- UTC build timestamps in commit subjects;
- versioned `pre-commit` and `prepare-commit-msg` hooks;
- rollover, amend, repeated-hook, malformed-version, and staged-file checks.

The skill never adds source-writing APIs or unrelated release automation.

### `handoff`

Creates or updates a concise root `HANDOFF.md` for explicit checkpoints,
milestones, pauses, blockers, and safe project resumption. It does not depend on
logout detection and does not commit or push automatically.

## Install

The skill is a standard `SKILL.md` package and can be copied into the personal
skill directory used by the agent:

| Runtime | Personal skill directory |
|---|---|
| Codex | `~/.codex/skills/alfazen-versioning` or `~/.agents/skills/alfazen-versioning` |
| Claude Code | `~/.claude/skills/alfazen-versioning` |
| Gemini CLI | `~/.gemini/skills/alfazen-versioning` or `~/.agents/skills/alfazen-versioning` |

From a clone of this repository, copy the `alfazen-versioning` directory to
the appropriate location. For Gemini CLI, development linking is also
available:

```sh
gemini skills link ./alfazen-versioning --scope user
```

Alternatively, install it globally for all three runtimes with `npx`:

```sh
npx skills add https://github.com/marcuz-apl/alfazen-skills/tree/master/alfazen-versioning -g -a claude-code -a codex -a gemini-cli --copy -y
```

Install only the handoff skill with:

```sh
npx skills add https://github.com/marcuz-apl/alfazen-skills/tree/master/handoff -g -a claude-code -a codex -a gemini-cli --copy -y
```

Verify the installation with:

```sh
npx skills list
```

After installation, invoke it by its name or ask the agent to configure or
audit Alfazen Versioning in a Git repository.

## License

This skill collection is released under the [MIT License](LICENSE). It is free
to use, copy, modify, redistribute, and include in commercial projects, subject
to the copyright and license notice.
