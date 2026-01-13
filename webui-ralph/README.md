# WebUI RALPH Loop

RALPH Loop for comprehensive Web UI visual verification. Runs an infinite loop until 95%+ confidence is achieved across all UI states.

## Overview

This plugin implements the RALPH (Recursive AI Loop for Persistent Handling) technique for Web UI verification. It continuously verifies UI quality until all completion criteria are met.

## Installation

```bash
claude plugin install webui-ralph@laststance
```

## Usage

```bash
# Start the verification loop
/webui-ralph

# Start with iteration limit
/webui-ralph --max-iterations 50

# Cancel an active loop
/cancel-webui-ralph
```

## How It Works

1. **Setup Script**: Creates state file (`.claude/webui-ralph.local.md`) with embedded verification prompt
2. **Stop Hook**: Monitors transcript for completion promise
3. **Loop Continues**: Same prompt is fed back until `<promise>VERIFICATION COMPLETE</promise>` is detected

## Completion Criteria

The loop completes ONLY when ALL of these are TRUE:

1. ALL screenshots in `claudedocs/screenshots/` have `verify_` prefix
2. ALL items in `claudedocs/ui_visual_test.md` are `[x]` checked
3. Final test run passed (`pnpm test` or `pnpm playwright test`)
4. Overall visual confidence is 95%+

## Triple-Criteria Evaluation

| Criterion | Weight | Evaluate |
|-----------|--------|----------|
| **Functional** | 40% | Displays correctly, data binds properly |
| **State Change** | 30% | Hover/Focus/Active work, transitions smooth |
| **Visual Design** | 30% | Matches Notion/YouTube/X quality level |

Score = (Functional × 0.4) + (State × 0.3) + (Visual × 0.3)

- 95%+ = PASS → add `verify_` prefix
- <95% = FAIL → fix and re-test

## Files

| File | Purpose |
|------|---------|
| `skills/webui-ralph/SKILL.md` | Main skill definition |
| `skills/cancel-webui-ralph/SKILL.md` | Cancel skill definition |
| `hooks/stop-hook.sh` | Loop continuation logic |
| `scripts/setup-webui-ralph.sh` | Initialize loop and state file |
| `templates/ui_visual_test.template.md` | Checklist template |

## Warning

**This loop cannot be stopped manually!** It will run until:
- The completion promise is output (only when genuinely complete)
- OR max iterations reached (if specified)

Use `/cancel-webui-ralph` to forcibly abort if needed.

## License

MIT
