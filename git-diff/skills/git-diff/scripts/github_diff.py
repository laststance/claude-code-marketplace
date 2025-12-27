#!/usr/bin/env python3
"""
GitHub-style unified diff viewer for terminal.

Displays git diff output with:
- File path headers
- Two-column line numbers (old | new)
- ANSI colors: red for deletions, green for additions
- Chunk markers with context info
"""

import subprocess
import sys
import re
from dataclasses import dataclass
from typing import Optional


# ANSI color codes
class Colors:
    """ANSI escape codes for terminal colors."""
    RESET = "\033[0m"
    BOLD = "\033[1m"
    DIM = "\033[2m"

    # Foreground
    RED = "\033[31m"
    GREEN = "\033[32m"
    CYAN = "\033[36m"
    WHITE = "\033[37m"

    # Background
    BG_RED = "\033[41m"
    BG_GREEN = "\033[42m"
    BG_DARK = "\033[48;5;236m"
    BG_HEADER = "\033[48;5;240m"


@dataclass
class DiffLine:
    """Represents a single line in the diff output."""
    old_num: Optional[int]
    new_num: Optional[int]
    content: str
    line_type: str  # 'add', 'del', 'context', 'header', 'chunk'


def run_git_diff(path: Optional[str] = None, cached: bool = False) -> str:
    """
    Execute git diff command and return output.

    Args:
        path: Optional file path to filter diff
        cached: If True, show staged changes (--cached)

    Returns:
        Raw git diff output string
    """
    cmd = ["git", "diff", "--no-color"]
    if cached:
        cmd.append("--cached")
    if path:
        cmd.extend(["--", path])

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return result.stdout
    except subprocess.CalledProcessError:
        return ""


def parse_diff(diff_output: str) -> list[dict]:
    """
    Parse git diff output into structured file diffs.

    Args:
        diff_output: Raw git diff string

    Returns:
        List of file diffs with parsed hunks
    """
    files = []
    current_file = None
    current_hunk = None
    old_line = 0
    new_line = 0

    for line in diff_output.split('\n'):
        # File header: diff --git a/path b/path
        if line.startswith('diff --git'):
            if current_file:
                files.append(current_file)
            match = re.search(r'b/(.+)$', line)
            filepath = match.group(1) if match else "unknown"
            current_file = {"path": filepath, "hunks": []}
            current_hunk = None

        # Chunk header: @@ -old,len +new,len @@ context
        elif line.startswith('@@'):
            match = re.match(r'@@ -(\d+)(?:,\d+)? \+(\d+)(?:,\d+)? @@(.*)', line)
            if match:
                old_line = int(match.group(1))
                new_line = int(match.group(2))
                context = match.group(3).strip()
                current_hunk = {"header": line, "context": context, "lines": []}
                if current_file:
                    current_file["hunks"].append(current_hunk)

        # Content lines
        elif current_hunk is not None:
            if line.startswith('-') and not line.startswith('---'):
                current_hunk["lines"].append(DiffLine(
                    old_num=old_line,
                    new_num=None,
                    content=line[1:],
                    line_type='del'
                ))
                old_line += 1
            elif line.startswith('+') and not line.startswith('+++'):
                current_hunk["lines"].append(DiffLine(
                    old_num=None,
                    new_num=new_line,
                    content=line[1:],
                    line_type='add'
                ))
                new_line += 1
            elif line.startswith(' ') or line == '':
                content = line[1:] if line.startswith(' ') else ''
                current_hunk["lines"].append(DiffLine(
                    old_num=old_line,
                    new_num=new_line,
                    content=content,
                    line_type='context'
                ))
                old_line += 1
                new_line += 1

    if current_file:
        files.append(current_file)

    return files


def format_line_number(num: Optional[int], width: int = 4) -> str:
    """Format line number with padding, or empty if None."""
    if num is None:
        return " " * width
    return str(num).rjust(width)


def render_diff(files: list[dict], section_title: str = "") -> str:
    """
    Render parsed diff files with GitHub-style formatting.

    Args:
        files: Parsed file diffs from parse_diff()
        section_title: Optional section header (e.g., "Staged" or "Unstaged")

    Returns:
        Formatted diff string with ANSI colors
    """
    output = []
    C = Colors

    if section_title:
        output.append(f"\n{C.BOLD}{C.CYAN}{'─' * 50}{C.RESET}")
        output.append(f"{C.BOLD}{C.CYAN} {section_title}{C.RESET}")
        output.append(f"{C.BOLD}{C.CYAN}{'─' * 50}{C.RESET}\n")

    for file in files:
        # File header
        output.append(f"{C.BG_HEADER}{C.BOLD}{C.WHITE}  {file['path']} {C.RESET}")
        output.append("")

        for hunk in file["hunks"]:
            # Chunk header (@@ ... @@)
            output.append(f"{C.CYAN}{hunk['header']}{C.RESET}")

            for line in hunk["lines"]:
                old_num = format_line_number(line.old_num)
                new_num = format_line_number(line.new_num)

                if line.line_type == 'del':
                    # Deleted line: red background
                    marker = f"{C.RED}-{C.RESET}"
                    content = f"{C.BG_RED}{C.WHITE}{line.content}{C.RESET}"
                    nums = f"{C.DIM}{old_num}{C.RESET}      "
                elif line.line_type == 'add':
                    # Added line: green background
                    marker = f"{C.GREEN}+{C.RESET}"
                    content = f"{C.BG_GREEN}{C.WHITE}{line.content}{C.RESET}"
                    nums = f"      {C.DIM}{new_num}{C.RESET}"
                else:
                    # Context line
                    marker = " "
                    content = line.content
                    nums = f"{C.DIM}{old_num}  {new_num}{C.RESET}"

                output.append(f"{nums} {marker} {content}")

            output.append("")

    return '\n'.join(output)


def main():
    """
    Main entry point for git-diff skill.

    Usage: github_diff.py [path]
    """
    path = sys.argv[1] if len(sys.argv) > 1 else None
    C = Colors

    # Get both unstaged and staged diffs
    unstaged_raw = run_git_diff(path, cached=False)
    staged_raw = run_git_diff(path, cached=True)

    if not unstaged_raw and not staged_raw:
        print(f"\n{C.DIM}No changes detected{C.RESET}")
        print(f"{C.DIM}   Working tree is clean{C.RESET}\n")
        return

    # Parse and render diffs
    if staged_raw:
        staged_files = parse_diff(staged_raw)
        if staged_files:
            print(render_diff(staged_files, "Staged Changes (--cached)"))

    if unstaged_raw:
        unstaged_files = parse_diff(unstaged_raw)
        if unstaged_files:
            print(render_diff(unstaged_files, "Unstaged Changes"))


if __name__ == "__main__":
    main()
