---
name: cancel-webui-ralph
description: |
  Cancel an active WebUI RALPH Loop.

  Use when:
  - User wants to stop/cancel the UI verification loop
  - User invokes /cancel-webui-ralph

  Keywords: "cancel", "stop", "abort", "キャンセル", "中止"
allowed-tools: "Bash"
---

# Cancel WebUI RALPH Loop

Cancel an active WebUI RALPH Loop by removing the state file.

## Usage

```bash
if [ -f ".claude/webui-ralph.local.md" ]; then
  rm ".claude/webui-ralph.local.md"
  echo "✅ WebUI RALPH Loop cancelled."
  echo "   State file removed: .claude/webui-ralph.local.md"
else
  echo "ℹ️  No active WebUI RALPH Loop found."
fi
```

## When to Use

Use this skill when:
- The user explicitly requests to stop the verification loop
- An error condition requires aborting the process
- The user wants to restart with different parameters

## Note

This command removes the state file that the stop hook checks.
Without the state file, the stop hook allows normal session exit.
