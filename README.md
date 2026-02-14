# Laststance Claude Code Marketplace

This repository hosts the Laststance plugin marketplace definition for Claude Code and the source for the `mac-notification-hook` plugin.

## Marketplace Contents
- `mac-notification-hook` – Sends native macOS desktop notifications whenever Claude Code emits `Notification` hook events.
- `pwa-assets-generator` – Generate all required PWA assets from a single 1024x1024px image.
- `git-diff` – GitHub-style unified diff viewer with colored terminal output.
- `qa-team` – Launch comprehensive QA Agent Team for post-implementation verification with 5 specialist perspectives (Visual, Functional, HIG, Edge Cases, UX).

## ⚠️ Known Limitations

**Due to a Claude Code bug ([Issue #9708](https://github.com/anthropics/claude-code/issues/9708)), the Notification hook does not work when installed via the plugin marketplace.**

Until this issue is resolved, please use the **manual installation method** below.

## 📦 Installation Methods

### Method 1: Manual Installation (Recommended - Works Reliably)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/laststance/claude-code-marketplace.git
   cd claude-code-marketplace
   ```

2. **Copy the script to your Claude Code hooks directory:**
   ```bash
   mkdir -p ~/.claude/hooks
   cp mac-notification-hook/hooks/notification-hook.sh ~/.claude/hooks/
   chmod +x ~/.claude/hooks/notification-hook.sh
   ```

3. **Edit your Claude Code settings file:**

   Open `~/.claude/settings.json` and add or edit the `hooks` section as follows:

   ```json
   {
     "hooks": {
       "Notification": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "~/.claude/hooks/notification-hook.sh"
             }
           ]
         }
       ]
     }
   }
   ```

4. **Reload hooks in Claude Code:**
   ```
   /hooks
   ```

5. **Verify:**

   Execute any task in Claude Code and you should see a macOS desktop notification.

#### Requirements
- **jq**: Required for JSON processing
  ```bash
  brew install jq
  ```
- **terminal-notifier** (Optional - Recommended for better notification experience):
  ```bash
  brew install terminal-notifier
  ```

### Method 2: Marketplace Installation (Currently Not Working - Waiting for Bug Fix)

~~1. From Claude Code, add this marketplace:~~
   ```
   /plugin marketplace add https://github.com/laststance/claude-code-marketplace
   ```
~~2. Install the Mac Notification Hook plugin:~~
   ```
   /plugin install mac-notification-hook@laststance
   ```
~~3. Restart Claude Code if prompted, then verify the hook is active by triggering a tool event that emits a notification.~~

**Note**: This method currently does not work due to a Claude Code bug. Please use Method 1 (manual installation) instead.

## Repository Structure
```
.
├── .claude-plugin/
│   └── marketplace.json      # Marketplace manifest (required)
├── mac-notification-hook/    # macOS notification hook plugin
├── pwa-assets-generator/     # PWA asset generation plugin
├── git-diff/                 # Git diff viewer plugin
├── gif-analyzer/             # GIF frame analysis plugin
├── qa-team/                  # QA Agent Team plugin
│   ├── .claude-plugin/
│   │   └── plugin.json       # Plugin metadata
│   ├── skills/qa-team/       # Skill with references, scripts, workflows
│   └── README.md             # Plugin-specific instructions
└── LICENSE                   # Project license (MIT)
```

## 🔧 Configuration Options

You can customize the script behavior using environment variables:

| Environment Variable | Description | Default Value |
|---------------------|-------------|---------------|
| `CLAUDE_NOTIFICATION_SOUND` | Name of the notification sound | `"Ping"` |
| `CLAUDE_NOTIFICATION_TERMINAL_APP` | Terminal application name | `$TERM_PROGRAM` |
| `CLAUDE_NOTIFICATION_ACTIVATE_BUNDLE` | Bundle ID to activate on click | Auto-detected |
| `CLAUDE_NOTIFICATION_FALLBACK_BUNDLE` | Fallback Bundle ID | `"com.apple.Terminal"` |

**Configuration example** (`~/.zshrc` or `~/.bashrc`):
```bash
export CLAUDE_NOTIFICATION_SOUND="Glass"
export CLAUDE_NOTIFICATION_TERMINAL_APP="iTerm.app"
```

## 🐛 Troubleshooting

### If notifications are not appearing

1. **Check the logs:**
   ```bash
   tail -f ~/.claude/hooks/logs/notification-hook.log
   ```

2. **Verify jq is installed:**
   ```bash
   which jq
   # If not installed:
   brew install jq
   ```

3. **Verify the script is executable:**
   ```bash
   ls -l ~/.claude/hooks/notification-hook.sh
   # If not executable:
   chmod +x ~/.claude/hooks/notification-hook.sh
   ```

4. **Verify settings.json is configured correctly:**
   ```bash
   cat ~/.claude/settings.json
   ```

5. **Reload hooks:**
   ```
   /hooks
   ```

### For a better notification experience

Install `terminal-notifier` to enable focus switching to your terminal when clicking notifications:

```bash
brew install terminal-notifier
```

## 🔄 Update Workflow

1. Modify the plugin or marketplace files as needed.
2. Bump the `version` fields in both the plugin manifest and marketplace entry when releasing updates.
3. Commit and push the changes so clients subscribed to the marketplace can refresh and install the latest version.

## 📚 Additional Resources

- [Claude Code Plugins Reference](https://docs.claude.com/en/docs/claude-code/plugins-reference)
- [Claude Code Hooks Guide](https://docs.claude.com/en/docs/claude-code/hooks-guide)
- [Issue #9708 - Plugin Notification hook command may not be executed](https://github.com/anthropics/claude-code/issues/9708)
