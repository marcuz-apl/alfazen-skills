---
name: figma
description: "Design-to-code workflows, Figma REST API integration, design token extraction, component mapping, Auto Layout to CSS translation, and SVG asset synchronization."
---

# Figma Skill

Comprehensive toolkit and guidelines for translating Figma designs, tokens, components, and assets into production code.

## Core Workflows

### 1. Design Tokens & Variables Extraction
- Extract color variables, typography scales, spacing tokens, and border radii from Figma files.
- Map Figma tokens to project CSS variables (e.g. `var(--primary)`, `var(--background)`, `var(--radius)`).

### 2. Auto Layout to CSS Translation
- `Auto Layout (Horizontal)` $\rightarrow$ `display: flex; flex-direction: row;`
- `Auto Layout (Vertical)` $\rightarrow$ `display: flex; flex-direction: column;`
- `Gap / Item Spacing` $\rightarrow$ `gap: Xpx;`
- `Padding (Top, Right, Bottom, Left)` $\rightarrow$ `padding: ...;`
- `Hug Contents` $\rightarrow$ `width: fit-content;` / `height: fit-content;`
- `Fill Container` $\rightarrow$ `flex: 1;` or `width: 100%;`

### 3. SVG & Asset Optimization
- Export vector icons as clean, accessible SVGs (strip hardcoded dimensions if responsive sizing is required).
- Use proper `viewBox`, `fill="currentColor"` for dynamic icon theming.

### 4. Figma API & MCP Tools
- When Figma MCP is configured, use `get_file`, `get_node`, `get_images` to fetch nodes, images, and inspect component properties directly.
