# git-diff

GitHub-style unified diff viewer for Claude Code.

## Overview

Display git changes with beautiful, GitHub-inspired formatting directly in your terminal. Shows both staged and unstaged changes with:

- Two-column line numbers (old | new)
- Red/green syntax highlighting for deletions/additions
- Clear file headers and chunk markers
- ANSI color support for terminal output

## Installation

```bash
# Add the Laststance marketplace (if not already added)
/plugin marketplace add laststance

# Install the plugin
/plugin install git-diff@laststance
```

## Usage

Once installed, Claude will automatically use this skill when you ask about git changes:

```
# Natural language triggers
"Show me the git diff"
"What changed in my code?"
"Review the current changes"

# Direct invocation
git diff
```

### Manual Script Usage

```bash
# Show all changes
python3 skills/git-diff/scripts/github_diff.py

# Filter by path
python3 skills/git-diff/scripts/github_diff.py src/components/
```

## Output Example

```
──────────────────────────────────────────────────
 Staged Changes (--cached)
──────────────────────────────────────────────────

  src/app.tsx

@@ -10,6 +10,7 @@
  10    10    import { Header } from './components';
  11    11    import { Footer } from './components';
  12       -  import { OldComponent } from './old';
        12 +  import { NewComponent } from './new';
  13    13
```

## Features

| Feature | Description |
|---------|-------------|
| **Staged Changes** | Shows `git diff --cached` first |
| **Unstaged Changes** | Shows working directory modifications |
| **Line Numbers** | Two-column display (old \| new) |
| **Color Coding** | Red for deletions, green for additions |
| **Chunk Headers** | Cyan `@@ -n,m +n,m @@` markers |

## Requirements

- Python 3.6+
- Git installed and in PATH
- Terminal with ANSI color support

## License

MIT
