#!/usr/bin/env bash
# Claude Code Notification Hook - Send desktop notification when notifications occur
# 🎯 Hook to send desktop notifications when Notification events occur

set -euo pipefail

# Determine notification sending method (prioritize terminal-notifier for focus control on click)
HAS_TERMINAL_NOTIFIER=false
if command -v terminal-notifier >/dev/null 2>&1; then
    HAS_TERMINAL_NOTIFIER=true
fi

# Logging configuration
LOG_FILE="$HOME/.claude/hooks/logs/notification-hook.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Check for jq required for JSON processing
if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required but not installed" >&2
    exit 1
fi

# Confirm availability of osascript for fallback (required only when terminal-notifier is not available)
if [[ "$HAS_TERMINAL_NOTIFIER" == false ]] && ! command -v osascript >/dev/null 2>&1; then
    echo "Neither terminal-notifier (preferred) nor osascript (fallback) is available" >&2
    exit 1
fi

# Determine the Bundle ID of the terminal to focus when notification is clicked
TARGET_BUNDLE=""
if [[ -n "${CLAUDE_NOTIFICATION_ACTIVATE_BUNDLE:-}" ]]; then
    TARGET_BUNDLE="$CLAUDE_NOTIFICATION_ACTIVATE_BUNDLE"
else
    case "${CLAUDE_NOTIFICATION_TERMINAL_APP:-${TERM_PROGRAM:-}}" in
        Apple_Terminal|"")
            TARGET_BUNDLE="com.apple.Terminal"
            ;;
        iTerm.app)
            TARGET_BUNDLE="com.googlecode.iterm2"
            ;;
        WezTerm)
            TARGET_BUNDLE="com.github.wez.WezTerm"
            ;;
        WarpTerminal)
            TARGET_BUNDLE="dev.warp.Warp-Stable"
            ;;
        Hyper)
            TARGET_BUNDLE="co.zeit.hyper"
            ;;
        Ghostty)
            TARGET_BUNDLE="com.mitchellh.ghostty"
            ;;
        *)
            TARGET_BUNDLE="${CLAUDE_NOTIFICATION_FALLBACK_BUNDLE:-com.apple.Terminal}"
            printf "[%s] Unknown terminal '%s'; using fallback bundle '%s'\n" \
                "$TIMESTAMP" "${CLAUDE_NOTIFICATION_TERMINAL_APP:-${TERM_PROGRAM:-}}" "$TARGET_BUNDLE" >> "$LOG_FILE"
            ;;
    esac
fi

# Read input data
INPUT=$(cat)

# Get event name
HOOK_EVENT_NAME=$(echo "$INPUT" | jq -r '.hook_event_name // empty')

printf "[%s] Notification hook triggered for: %s\n" "$TIMESTAMP" "$HOOK_EVENT_NAME" >> "$LOG_FILE"

# Process only Notification events
if [[ "$HOOK_EVENT_NAME" == "Notification" ]]; then
    printf "[%s] Processing Notification event\n" "$TIMESTAMP" >> "$LOG_FILE"

    # Get notification message
    MESSAGE=$(echo "$INPUT" | jq -r '.message // "通知が発生しました"')
    SOUND_NAME=${CLAUDE_NOTIFICATION_SOUND:-"Ping"}

    if [[ "$HAS_TERMINAL_NOTIFIER" == true ]]; then
        NOTIFIER_CMD=(terminal-notifier -title "Claude Code" -message "$MESSAGE" -sound "$SOUND_NAME" -group "claude-code-notifications")
        if [[ -n "$TARGET_BUNDLE" ]]; then
            NOTIFIER_CMD+=(-activate "$TARGET_BUNDLE")
        fi

        if "${NOTIFIER_CMD[@]}"; then
            printf "[%s] Notification sent via terminal-notifier (activate=%s): %s (sound=%s)\n" \
                "$TIMESTAMP" "$TARGET_BUNDLE" "$MESSAGE" "$SOUND_NAME" >> "$LOG_FILE"
        else
            STATUS=$?
            printf "[%s] terminal-notifier failed (exit code: %d); attempting osascript fallback\n" \
                "$TIMESTAMP" "$STATUS" >> "$LOG_FILE"
            if command -v osascript >/dev/null 2>&1 && \
               osascript -e 'on run argv' \
                         -e 'display notification (item 1 of argv) with title "Claude Code" sound name (item 2 of argv)' \
                         -e 'end run' \
                         "$MESSAGE" "$SOUND_NAME"; then
                printf "[%s] Fallback osascript notification sent: %s (sound=%s)\n" \
                    "$TIMESTAMP" "$MESSAGE" "$SOUND_NAME" >> "$LOG_FILE"
            else
                printf "[%s] Failed to send notification via both terminal-notifier and osascript\n" \
                    "$TIMESTAMP" >> "$LOG_FILE"
                exit "${STATUS:-1}"
            fi
        fi
    else
        if osascript -e 'on run argv' \
                     -e 'display notification (item 1 of argv) with title "Claude Code" sound name (item 2 of argv)' \
                     -e 'end run' \
                     "$MESSAGE" "$SOUND_NAME"; then
            printf "[%s] Notification sent successfully via osascript: %s (sound=%s)\n" \
                "$TIMESTAMP" "$MESSAGE" "$SOUND_NAME" >> "$LOG_FILE"
        else
            STATUS=$?
            printf "[%s] Failed to send notification via osascript (exit code: %d): %s (sound=%s)\n" \
                "$TIMESTAMP" "$STATUS" "$MESSAGE" "$SOUND_NAME" >> "$LOG_FILE"
            exit "$STATUS"
        fi
    fi

else
    printf "[%s] Ignoring non-Notification event: %s\n" "$TIMESTAMP" "$HOOK_EVENT_NAME" >> "$LOG_FILE"
fi

# Always allow (notifications run in background)
echo '{"permissionDecision": "allow"}'
exit 0
