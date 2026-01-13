---
name: webui-ralph
description: |
  Start WebUI RALPH Loop for comprehensive UI visual verification.
  Runs infinite loop until 95%+ confidence across all UI states.

  Use when:
  - User requests UI visual verification
  - User wants to check frontend quality
  - User invokes /webui-ralph

  Keywords: "UI verification", "visual check", "frontend QA", "screenshot verify",
  "RALPH loop", "webui-ralph", "UI検証", "視覚検証"

  NOTE: This skill runs as an INFINITE LOOP until completion criteria met.
allowed-tools: "Bash,Read,Write,Edit,Glob,Grep,MCPSearch,mcp__claude-in-chrome__*,mcp__mac-mcp-server__take_screenshot"
---

# WebUI RALPH Loop

Start the WebUI RALPH Loop for comprehensive UI visual verification.

## Usage

```bash
# Start with unlimited iterations
"${CLAUDE_PLUGIN_ROOT}/scripts/setup-webui-ralph.sh"

# Or with iteration limit
"${CLAUDE_PLUGIN_ROOT}/scripts/setup-webui-ralph.sh" --max-iterations 50
```

## How It Works

1. **Setup Script** creates state file with embedded verification prompt
2. **Stop Hook** monitors for completion promise in output
3. **Loop continues** until `<promise>VERIFICATION COMPLETE</promise>` is detected

## Completion Criteria

You may ONLY output `<promise>VERIFICATION COMPLETE</promise>` when ALL:

1. ALL screenshots have `verify_` prefix (95%+ confidence)
2. ALL items in `claudedocs/ui_visual_test.md` are `[x]` checked
3. Final tests passed
4. Overall confidence is 95%+

## Instructions

When this skill is invoked:

1. Execute the setup script to initialize the RALPH loop
2. Follow the embedded verification workflow
3. Continue until ALL completion criteria are genuinely satisfied
4. Output the completion promise ONLY when truly complete

**CRITICAL**: Do NOT output the promise to escape the loop. The loop will continue automatically until genuine completion.
