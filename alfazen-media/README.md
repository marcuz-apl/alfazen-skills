# Alfazen Media Skills

Reusable Agent Skills for generative media, animation, video programming, character design, and timeline sequencing.

## Included Skills

- **[`character`](character/SKILL.md)**: Consistent character persona design, expression sheets, turnarounds, and visual style preservation.
- **[`hyperframes`](hyperframes/SKILL.md)**: High-performance generative motion graphics, WebGL shaders, and canvas frame keyframing.
- **[`remotion`](remotion/SKILL.md)**: Programmatic video composition and rendering with React and Remotion.
- **[`sequence`](sequence/SKILL.md)**: Director-level storyboarding, camera blocking, pacing rhythm, and scene sequence orchestration.

## Installation

### Option A: Natural Language Prompt (Ask Your AI Agent)

> *"Please install the `alfazen-media` bundle skills from https://github.com/marcuz-apl/alfazen-skills.git"*

### Option B: Install All Media Skills via `npx`

```sh
npx skills add https://github.com/marcuz-apl/alfazen-skills/tree/master/alfazen-media -g -a claude-code -a codex -a gemini-cli --copy -y
```

### Option C: Install a Specific Skill via `npx`

```sh
npx skills add https://github.com/marcuz-apl/alfazen-skills/tree/master/alfazen-media/remotion -g -a claude-code -a codex -a gemini-cli --copy -y
```

## Acknowledgements & Sources

- **[Remotion Skills](https://github.com/remotion-dev/skills)** by Remotion Team (`remotion`)
- **[HyperFrames](https://github.com/heygen-com/hyperframes)** by HeyGen / HyperFrames Team (`hyperframes`)
- **Unknown Geeks & Community Creators** (`character`, `sequence`)
