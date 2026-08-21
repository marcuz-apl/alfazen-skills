# Anthropic Selected Skills

This folder contains three selected skills from [Anthropic's official skills repository](https://github.com/anthropics/skills):

- `claude-api`
- `academy-guide`
- `brand-guidelines`

These skills are intended for Claude Code only. They are deliberately kept
outside the `alfazen-coding` and `alfazen-media` bundles so the generic
multi-agent installation commands do not install them into Codex or Gemini.

Install them into Claude Code with:

```sh
npx skills add https://github.com/marcuz-apl/alfazen-skills/tree/master/anthropic-selected -g -a claude-code --copy -y
```

Each skill retains its upstream `LICENSE.txt`.
