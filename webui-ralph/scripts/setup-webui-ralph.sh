#!/bin/bash

# WebUI RALPH Loop Setup Script
# Creates state file with embedded UI verification prompt

set -euo pipefail

# Parse arguments
MAX_ITERATIONS=0

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      cat << 'HELP_EOF'
WebUI RALPH Loop - Web UI Visual Verification

USAGE:
  /webui-ralph [OPTIONS]

OPTIONS:
  --max-iterations <n>   Maximum iterations before auto-stop (default: unlimited)
  -h, --help             Show this help message

DESCRIPTION:
  Starts a WebUI RALPH Loop for comprehensive UI visual verification.
  The loop continues until ALL verification criteria are met:

  1. All screenshots have verify_ prefix (95%+ confidence)
  2. All checklist items in ui_visual_test.md are checked
  3. Final tests pass

  To signal completion, output: <promise>VERIFICATION COMPLETE</promise>

  ONLY output this promise when ALL criteria are genuinely satisfied.

EXAMPLES:
  /webui-ralph                      # Run until complete
  /webui-ralph --max-iterations 50  # Limit to 50 iterations

STOPPING:
  Only by reaching --max-iterations or satisfying ALL verification criteria.
  The loop cannot be stopped manually!

MONITORING:
  grep '^iteration:' .claude/webui-ralph.local.md
  ls -la claudedocs/screenshots/ | grep -c verify_
HELP_EOF
      exit 0
      ;;
    --max-iterations)
      if [[ -z "${2:-}" ]] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "Error: --max-iterations requires a positive integer" >&2
        exit 1
      fi
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Create state file with embedded prompt
mkdir -p .claude
mkdir -p claudedocs/screenshots

cat > .claude/webui-ralph.local.md << 'STATEFILEEOF'
---
active: true
iteration: 1
max_iterations: MAX_ITERATIONS_PLACEHOLDER
completion_promise: "VERIFICATION COMPLETE"
started_at: "TIMESTAMP_PLACEHOLDER"
---

# Web UI Visual Verification - RALPH Loop

You are in a RALPH Loop for Web UI verification. Continue until ALL completion criteria are met.

## CRITICAL: Completion Criteria

You may ONLY output `<promise>VERIFICATION COMPLETE</promise>` when ALL of these are TRUE:

1. [ ] ALL screenshots in `claudedocs/screenshots/` have `verify_` prefix
2. [ ] ALL items in `claudedocs/ui_visual_test.md` are `[x]` checked
3. [ ] Final test run passed (`pnpm test` or `pnpm playwright test`)
4. [ ] Overall visual confidence is 95%+

**DO NOT output the promise if ANY criterion is not met. Continue the loop instead.**

---

## Phase 0: Setup (First Iteration Only)

### 0.1 Platform Detection
Check `package.json`:
- If `"electron"` in dependencies → Use Electron MCP
- Otherwise → Use `mcp__claude-in-chrome__*`

### 0.2 Environment Check
```bash
pnpm dev  # Start dev server
```

### 0.3 MCP Connection
```
mcp__claude-in-chrome__tabs_context_mcp
```

### 0.4 Create Checklist
If `claudedocs/ui_visual_test.md` doesn't exist, create it with exploratory test items.

### 0.5 Screenshot Tool Setup (CRITICAL)

**You MUST use Playwright MCP to save screenshots to disk.**

Before taking screenshots, load the MCP tool:
```
MCPSearch({ query: "select:mcp__plugin_playwright_playwright__browser_take_screenshot" })
MCPSearch({ query: "select:mcp__plugin_playwright_playwright__browser_navigate" })
```

Screenshot workflow:
```
1. mcp__plugin_playwright_playwright__browser_navigate (url: "http://localhost:xxxx") → Navigate to page
2. mcp__plugin_playwright_playwright__browser_take_screenshot (filename: "path/to/file.png") → SAVE to disk
3. Read("path/to/file.png") → Verify file was saved correctly
```

**Note**: Playwright MCP provides smaller file sizes than mac-mcp, avoiding API limits.

---

## Phase 1: Exploratory Testing

### 1.1 Page Navigation
For each page:
1. Navigate to page using `mcp__plugin_playwright_playwright__browser_navigate`
2. **CRITICAL: Save screenshot to file** using:
   ```
   mcp__plugin_playwright_playwright__browser_take_screenshot({
     filename: "claudedocs/screenshots/<page>_<state>.png"
   })
   ```
3. Read the saved screenshot file and evaluate with Triple-Criteria
4. If 95%+ → rename file: `mv claudedocs/screenshots/<page>_<state>.png claudedocs/screenshots/verify_<page>_<state>.png`
5. If <95% → fix issues, re-capture

**Note**: Playwright MCP provides smaller, optimized screenshots suitable for API usage.

### 1.2 Edge Case Testing

Test ALL of these patterns:

#### Long Content
- [ ] 300+ character input fields
- [ ] 300+ character display areas
- [ ] 100+ character titles

#### Many Items / Empty States
- [ ] 50+ item lists
- [ ] 100+ row tables
- [ ] Empty list state
- [ ] No search results
- [ ] New user empty state

#### Interactive States
- [ ] Button hover (Primary/Secondary/Ghost)
- [ ] Link hover (nav/inline)
- [ ] Input focus states
- [ ] Button active states
- [ ] Toggle/switch active

#### Forms
- [ ] Empty/placeholder state
- [ ] Filled state
- [ ] Error state with messages
- [ ] Success state
- [ ] Disabled state

#### Loading/Transitions
- [ ] Page load skeleton/spinner
- [ ] Button loading state
- [ ] Modal open/close
- [ ] Tab switching
- [ ] Route transitions

#### Responsive
- [ ] Desktop (1440px+)
- [ ] Tablet (768px-1024px)
- [ ] Mobile (<768px)

### 1.3 Triple-Criteria Evaluation

| Criterion | Weight | Evaluate |
|-----------|--------|----------|
| **Functional** | 40% | Displays correctly, data binds properly |
| **State Change** | 30% | Hover/Focus/Active work, transitions smooth |
| **Visual Design** | 30% | Matches Notion/YouTube/X quality level |

**Score** = (Functional × 0.4) + (State × 0.3) + (Visual × 0.3)

- 95%+ = PASS → add `verify_` prefix
- <95% = FAIL → fix and re-test

---

## Phase 2: Cross-Verification Loop

### 2.1 Check File Status (CRITICAL)
**Verify screenshots were ACTUALLY saved to disk:**
```bash
ls -la claudedocs/screenshots/
```

Expected output should show `.png` files with non-zero size:
```
-rw-r--r--  1 user  staff  150000 Jan 13 10:00 home_initial.png
-rw-r--r--  1 user  staff  180000 Jan 13 10:01 verify_dashboard_table.png
```

**If directory is empty**: Screenshots were NOT saved. Go back to Phase 0.5 and use Playwright MCP screenshot tool.

### 2.2 Status Decision

| Situation | Action |
|-----------|--------|
| Directory is empty | 🔴 Go back to Phase 0.5, re-take screenshots with Playwright MCP |
| All files have `verify_` | → Continue to 2.3 |
| Some files missing `verify_` | → Review, fix, rename, continue loop |

### 2.3 Checklist Verification
Read `claudedocs/ui_visual_test.md`:
- All `[x]` → Continue to 2.4
- Some `[ ]` remaining → Execute those items, continue loop

### 2.4 Final Test
```bash
pnpm test
# or
pnpm playwright test
```

### 2.5 Completion Check

**ALL TRUE?**
- [ ] All screenshots `verify_*`
- [ ] All checklist items `[x]`
- [ ] Tests passed
- [ ] 95%+ confidence

**If YES:**
```xml
<promise>VERIFICATION COMPLETE</promise>
```

**If NO:**
- Identify remaining issues
- Fix and continue loop

---

## Visual Design Reference (Notion/YouTube/X Standard)

| Aspect | Question |
|--------|----------|
| **Colors** | Natural? Not too saturated/desaturated? |
| **Layout** | Proper spacing? Not cramped/too sparse? |
| **Typography** | Readable size? Clear hierarchy? |
| **Icons** | Appropriate size relative to surroundings? |
| **Overall** | Would fit as Notion/YouTube/X feature? |

**If ANY doubt → Fix first**

---

## Screenshot Naming Convention

Pattern: `[verify_]<page>_<component>_<state>.png`

| Segment | Examples |
|---------|----------|
| page | `home`, `settings`, `dashboard`, `login` |
| component | `header`, `modal`, `form`, `table`, `sidebar` |
| state | `initial`, `hover`, `loading`, `error`, `success`, `empty` |

Examples:
- `home_hero_initial.png` → Unverified
- `verify_home_hero_initial.png` → Verified (95%+)
- `verify_dashboard_table_empty.png` → Verified empty state

---

## DO NOT STOP UNTIL COMPLETE

This loop will continue automatically. You cannot exit until:
1. `<promise>VERIFICATION COMPLETE</promise>` is output (only when truly complete)
2. OR max iterations reached

**Do not lie to exit.** Continue working until genuinely complete.

STATEFILEEOF

# Replace placeholders
sed -i '' "s/MAX_ITERATIONS_PLACEHOLDER/$MAX_ITERATIONS/" .claude/webui-ralph.local.md
sed -i '' "s/TIMESTAMP_PLACEHOLDER/$(date -u +%Y-%m-%dT%H:%M:%SZ)/" .claude/webui-ralph.local.md

# Output setup message
cat << EOF
=====================================================
   WebUI RALPH Loop - Visual Verification Started
=====================================================

Iteration: 1
Max iterations: $(if [[ $MAX_ITERATIONS -gt 0 ]]; then echo $MAX_ITERATIONS; else echo "unlimited"; fi)
Completion promise: VERIFICATION COMPLETE

The stop hook is now active. When you try to exit, the SAME PROMPT
will be fed back to you until ALL verification criteria are met.

Completion Criteria:
  1. All screenshots have verify_ prefix (95%+ confidence)
  2. All checklist items checked in ui_visual_test.md
  3. Final tests passed
  4. Overall confidence 95%+

To complete, output: <promise>VERIFICATION COMPLETE</promise>
(ONLY when ALL criteria are genuinely satisfied)

WARNING: This loop cannot be stopped manually!

Monitor progress:
  grep '^iteration:' .claude/webui-ralph.local.md
  ls claudedocs/screenshots/ | grep -c verify_
=====================================================

Begin Web UI Visual Verification...

EOF
