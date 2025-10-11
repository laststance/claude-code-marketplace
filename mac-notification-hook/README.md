# Mac Notification Hook

Mac Notification Hook is a Claude Code plugin that turns every `Notification` event into a macOS desktop alert. It ships as a single hook that runs a hardened shell script, making it easy to stay on top of tool output without keeping Claude Code in the foreground.

## Features
- Sends rich desktop notifications via `terminal-notifier` with automatic `osascript` fallback
- Targets the correct terminal application so focus returns to your workspace when you click the alert
- Provides configurable sound and activation behaviour through environment variables
- Persists a structured activity log at `~/.claude/hooks/logs/notification-hook.log`

## Requirements
- macOS with either [`terminal-notifier`](https://github.com/julienXX/terminal-notifier) or AppleScript (`osascript`) available
- [`jq`](https://stedolan.github.io/jq/) for processing the Claude Code hook payload
- Claude Code (or the Codex CLI) with plugin hooks enabled

## Installation
1. Add this marketplace collection to Claude Code:
   ```
   /plugin marketplace add https://github.com/laststance/claude-code-marketplace.git
   ```
2. Install the plugin:
   ```
   /plugin install mac-notification-hook@laststance
   ```
3. Restart Claude Code to ensure the hook is registered.

### Manual Installation
If you prefer to manage the plugin manually:
1. Clone the repository or copy this directory into your project:
   ```bash
   git clone https://github.com/laststance/claude-code-marketplace.git
   cd claude-code-marketplace/mac-notification-hook
   ```
2. Create (or reuse) the Claude plugin directory and copy the files:
   ```bash
   mkdir -p "$HOME/.claude/plugins/mac-notification-hook"
   cp -R . "$HOME/.claude/plugins/mac-notification-hook"
   ```
3. Restart Claude Code.

## Hook Configuration
The plugin manifest (`.claude-plugin/plugin.json`) loads `hooks/hooks.json`, which registers a single `Notification` hook:
```json
{
  "hooks": {
    "Notification": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/notification-hook.sh"
          }
        ]
      }
    ]
  }
}
```
`notification-hook.sh` consumes the JSON payload from Claude Code and emits `{"permissionDecision": "allow"}` so downstream tools continue to run without interruption.

## Configuration
The script honours the following environment variables:
- `CLAUDE_NOTIFICATION_ACTIVATE_BUNDLE` — Explicit macOS bundle ID to bring to the foreground when a notification is clicked.
- `CLAUDE_NOTIFICATION_TERMINAL_APP` — Terminal name hint (`Apple_Terminal`, `iTerm.app`, `WezTerm`, `WarpTerminal`, `Hyper`, `Ghostty`). When set, the hook maps it to the correct bundle ID.
- `CLAUDE_NOTIFICATION_FALLBACK_BUNDLE` — Bundle ID used when the terminal cannot be inferred; defaults to `com.apple.Terminal`.
- `CLAUDE_NOTIFICATION_SOUND` — macOS system sound name; defaults to `Ping`.

Set these variables in your shell profile or within Claude Code's environment configuration to customise behaviour.

## Verifying the Hook
1. Trigger a Claude Code action that raises a notification (for example, run a tool that reports completion).
2. Observe the macOS notification; clicking it should focus the configured terminal.
3. Review the log file at `~/.claude/hooks/logs/notification-hook.log` for troubleshooting details.

## Troubleshooting
- If you see `jq is required but not installed`, install it via `brew install jq`.
- When neither `terminal-notifier` nor `osascript` is available, the hook fails early; install one of them and retry.
- Delete the log file if it grows unexpectedly large; it will be recreated automatically.

## License
This project is released under the MIT License. See [LICENSE](./../LICENSE) for details.
