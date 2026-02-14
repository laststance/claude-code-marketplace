# QA Team Plugin

Launch a comprehensive QA Agent Team for post-implementation verification, testing 5 perspectives in parallel.

## Overview

This Claude Code plugin spawns a coordinated team of 6 QA agents that verify your implementation from multiple quality perspectives simultaneously. Each agent specializes in a different aspect of quality assurance, producing structured reports with screenshots and a composite quality score.

## Team Composition

| Role | Perspective | What It Checks |
|------|-------------|----------------|
| **qa-lead** | Orchestration | Coordinates team, aggregates reports, renders final verdict |
| **visual-tester** | Visual Integrity | Layout, responsive design, rendering accuracy (95% threshold) |
| **functional-tester** | Functional Correctness | User flows, Impact Propagation verification, regression |
| **hig-tester** | Apple HIG Compliance | Typography, tap areas, colors, spacing, motion, corner radius |
| **edge-case-tester** | Edge Cases | Long text, 100+ records, boundary values, overflow |
| **ux-tester** | UX Sensibility | Dark-on-dark contrast, missing feedback, inconsistency |

## Installation

Install this plugin from the Laststance marketplace:

```bash
# Add marketplace (first time only)
/plugin marketplace add https://github.com/laststance/claude-code-marketplace

# Install plugin
/plugin install qa-team@laststance
```

## Usage

### Basic QA Run

```
/qa-team
```

### Platform-Specific

```
/qa-team --platform web
/qa-team --platform electron
/qa-team --platform ios
/qa-team --platform macos
```

### Quick Mode (Visual + Functional Only)

```
/qa-team --quick
```

### Skip Specific Perspectives

```
/qa-team --skip edge
/qa-team --skip visual,ux
```

## Scoring Rubric

| Component | Weight | PASS Threshold |
|-----------|--------|---------------|
| Visual Integrity | 25% | 95% Triple-Criteria |
| Functional Correctness | 30% | 95% pass rate, P0=0 |
| Apple HIG Compliance | 15% | 80/100 composite |
| Edge Cases | 15% | 0 crashes |
| UX Sensibility | 15% | PH Visual 75/100, critical=0 |

**Final Verdict**: >= 85 PASS / 65-84 CONDITIONAL PASS / < 65 FAIL

## Output Structure

```
claudedocs/qa/
├── qa-test-plan.md              # Platform + test plan
├── qa-visual-integrity.md       # Visual report
├── qa-functional.md             # Functional report (with impact verification)
├── qa-hig-compliance.md         # HIG report
├── qa-edge-cases.md             # Edge case report
├── qa-ux-sensibility.md         # UX sensibility report
├── qa-summary.md                # Aggregated final verdict
└── screenshots/
    ├── visual_*.png
    ├── func_*.png
    ├── hig_*.png
    ├── edge_*.png
    └── ux_*.png
```

## Task Dependency Graph

```
Task 1: [qa-lead] Platform Detection & Test Plan
  ├── Task 2: [visual-tester]     Visual Integrity         (parallel)
  ├── Task 3: [functional-tester] Functional Correctness   (parallel)
  ├── Task 4: [hig-tester]        Apple HIG Compliance     (parallel)
  ├── Task 5: [edge-case-tester]  Edge Cases               (blockedBy: 3)
  ├── Task 6: [ux-tester]         UX Sensibility           (blockedBy: 2)
  ├── Task 7: [qa-lead]           Report Aggregation       (blockedBy: 2,3,4,5,6)
  └── Task 8: [qa-lead]           Final Quality Gate       (blockedBy: 7)
```

## Platform Detection

The plugin auto-detects the platform from `package.json`:

| Indicator | Detected Platform | MCP Used |
|-----------|-------------------|----------|
| `electron` dependency | Electron | `mcp__electron__*` |
| `expo` / `app.json` | iOS/Expo | `mcp__ios-simulator__*` |
| `.xcodeproj` / `Package.swift` | macOS | `mcp__mac-mcp-server__*` |
| Default | Web | `mcp__claude-in-chrome__*` / `mcp__plugin_playwright_playwright__*` |

## Prerequisites

- A running dev server or application for the project under test
- Appropriate MCP servers configured for your platform (Chrome, Playwright, Electron, iOS Simulator, or Mac MCP)

## Contributing

Found a bug or have a feature request? Please open an issue on the [repository](https://github.com/laststance/claude-code-marketplace/issues).

## License

MIT License - See LICENSE file for details

## Author

**Laststance**
- Email: ryota.murakami@laststance.io
- GitHub: [@laststance](https://github.com/laststance)
