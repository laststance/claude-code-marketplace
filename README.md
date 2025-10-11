# Laststance Claude Code Marketplace

This repository hosts the Laststance plugin marketplace definition for Claude Code and the source for the `mac-notification-hook` plugin.

## Marketplace Contents
- `mac-notification-hook` – Sends native macOS desktop notifications whenever Claude Code emits `Notification` hook events.

## Install the Marketplace Locally
1. From Claude Code, add this marketplace:
   ```
   /plugin marketplace add https://github.com/laststance/claude-code-marketplace
   ```
2. Install the Mac Notification Hook plugin:
   ```
   /plugin install mac-notification-hook@laststance
   ```
3. Restart Claude Code if prompted, then verify the hook is active by triggering a tool event that emits a notification.

## Repository Structure
```
.
├── .claude-plugin/
│   └── marketplace.json   # Marketplace manifest (required)
├── mac-notification-hook/ # Plugin source code and manifest
│   ├── .claude-plugin/
│   │   └── plugin.json    # Plugin metadata
│   ├── hooks/
│   │   └── hooks.json     # Hook wiring
│   └── README.md          # Plugin-specific instructions
├── AGENTS.md              # Reserved for future agent docs
└── LICENSE                # Project license (MIT)
```

## Update Workflow
1. Modify the plugin or marketplace files as needed.
2. Bump the `version` fields in both the plugin manifest and marketplace entry when releasing updates.
3. Commit and push the changes so clients subscribed to the marketplace can refresh and install the latest version.

For full schema details, refer to the [Claude Code Plugins Reference](https://docs.claude.com/en/docs/claude-code/plugins-reference).
