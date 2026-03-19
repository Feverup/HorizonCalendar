# Smart PR Command

This command analyzes the current branch and generates a comprehensive pull request description following the project's pull request guidelines.

## How It Works

When you invoke this command (e.g., via `/smart-pr`), the AI will:

1. **Check for GitHub CLI** using `which gh` or `gh --version`
2. **Get the current branch name** using `git branch --show-current`
3. **Extract the ticket identifier** from the branch name (e.g., PLATFORM-7505)
4. **Get the base branch** (typically `main` or `develop`) by checking common patterns or using `git remote show origin`
5. **Analyze the diff** between the base branch and current branch using `git diff`
6. **Review commit messages** in the current branch using `git log`
7. **Identify changed files** to determine if visual changes exist (UI components, views, etc.)
8. **Generate a PR title** in the format: `[TICKET-ID] Description`
9. **Create comprehensive PR description** with all required sections:
   - ℹ️ Context (with ticket link and problem statement)
   - 👷 Changes (high-level list of what changed)
   - ❓ Questions (optional - areas needing feedback)
   - ⚠️ Trade-offs & Tech Debt (important decisions and shortcuts)
   - 🧪 How to Test (detailed testing instructions)
   - 📱 Screenshots / Videos (only if visual changes detected)
10. **Calculate PR size** based on code-only diff lines (excluding images, docs, and generated files).
11. **Fetch available repository labels** (if GitHub CLI is installed):
    - Use `gh label list` to get all labels in the repository
    - Analyze label names and descriptions to determine which ones are appropriate for this PR
    - Select relevant labels based on:
      - Type of change (e.g., feature, bugfix, documentation)
      - Any other contextually relevant labels
12. **Create or output the PR**:
    - **If GitHub CLI is installed**: Automatically create the PR using `gh pr create` (do NOT use `--web` flag to avoid opening browser)
      - **Auto-assign** the PR creator as the assignee using `--assignee @me`
      - **Auto-label** with the selected repository labels and the calculated size label
    - **If GitHub CLI is NOT installed**: Output the PR title and description in a formatted way for manual copy-paste into GitHub's web interface
      - Include a note about the recommended size label and other suggested labels to apply manually

The command should intelligently:
- Detect if UI files were changed to determine if screenshots section is needed
- Infer the context from commit messages and code changes
- Suggest appropriate testing devices (iOS simulators and real devices)
- Identify potential trade-offs based on code patterns
- Generate the ticket URL automatically (format: https://feverup.atlassian.net/browse/TICKET-ID)
- Calculate size based ONLY on actual code changes (Swift files, config files, etc.)
- Exclude from size calculation: images, *.md files, generated files, and asset diffs
- Adapt behavior based on whether GitHub CLI is available or not

## Workflow

```
1. User invokes /smart-pr
2. Check if 'gh' command is available
3. Analyze current branch and changes
4. Calculate PR size based on code-only diff
5. IF GitHub CLI is available:
     → Fetch repository labels: `gh label list`
     → Analyze label descriptions and select appropriate ones
6. Generate PR title and description
7. IF GitHub CLI is available:
     → Execute `gh pr create` with:
       - Generated title and body
       - Auto-assign: --assignee @me
       - Auto-label: selected repository labels + size label
       - Do NOT use --web flag (no browser prompt)
   ELSE:
     → Output formatted title and description for manual copy-paste
     → Include note about recommended size label and other suggested labels
```

## Pull Request Guidelines

**IMPORTANT**: This command MUST follow the pull request guidelines defined in `.feverrules/rules/pull-request-guidelines.md`. Please read and apply all guidelines from that file when generating PR descriptions.

## Expected Output Format

### When GitHub CLI is Available

Execute `gh pr create` command with the generated title and body. The command MUST include:

**Required flags:**
- `--title` for the PR title (format: `[TICKET-ID] Description`)
- `--body` for the PR description (following PR template structure)
- `--assignee @me` to auto-assign the PR creator
- `--label` for comma-separated labels, including:
  - Size label (e.g., `size/m`)
  - Contextually relevant labels from `gh label list` based on their descriptions
- `--base` to specify the target branch (if not default)

**Important:**
- Do NOT use `--web` flag (avoid opening browser/prompting web interface)
- Handle errors gracefully (e.g., not authenticated, remote not set up)

**Example command:**
```bash
gh pr create \
  --title "[PLATFORM-7505] Add multi-category event filtering" \
  --body "<generated PR description>" \
  --assignee @me \
  --label "feature,size/m" \
  --base main
```

Note: The labels are intelligently selected from the repository's available labels based on their descriptions and the PR's content.

### When GitHub CLI is NOT Available

Display a clear, formatted output with sections for manual copy-paste:

1. **Installation Suggestion**: Inform the user they can install GitHub CLI with: `brew install gh`
2. **PR Title**: Show the generated title on its own line, clearly labeled
3. **Recommended Labels**: Show all suggested labels including size label (e.g., `feature`, `size/m`)
   - Note: These are intelligent suggestions based on code analysis, but since GitHub CLI is unavailable, labels weren't fetched from the repository
4. **PR Description**: Show the complete markdown description ready to copy

**Example output format:**
```
GitHub CLI is not installed. You can install it with: brew install gh

Alternatively, you can create the PR manually on GitHub:

---
PR Title:
[PLATFORM-7505] Add multi-category event filtering

Recommended Labels (based on code analysis):
- feature
- size/m

PR Description:
<complete markdown description here>
---

Note: These labels are suggestions. Please verify they exist in your repository and apply them when creating the PR.
```

The generated content should follow the structure in `.github/PULL_REQUEST_TEMPLATE.md`.

## PR Size Calculation

The size label is determined by counting ONLY actual code changes, using `git diff` with appropriate filters.

**Include in size calculation:**
- Swift files (*.swift)
- Configuration files (*.xcconfig, *.plist, etc.)
- Build files (Package.swift, project.pbxproj, etc.)
- Scripts (*.sh, *.rb, *.py, etc.)
- Any other source code files

**Exclude from size calculation:**
- Image files (*.png, *.jpg, *.svg, *.pdf in asset catalogs)
- Documentation files (*.md)
- Asset catalogs (*.xcassets/*) image content
- Generated files
- Lock files (Package.resolved, Podfile.lock, etc.)

**Implementation tip:** Use `git diff --numstat` and filter out binary files and documentation files to get accurate line counts.

## Label Selection

When GitHub CLI is available, fetch and intelligently select repository labels:

### Fetching Labels
Use `gh label list` to retrieve all available labels with their descriptions. The output format includes:
- Label name
- Label description
- Label color

### Selection Criteria
Analyze the PR changes and select labels based on:

**1. Change Type:**
- Look for labels like: `feature`, `bugfix`, `enhancement`, etc.
- Infer from commit messages and changes

**2. Status/Priority:**
- Look for labels like: `urgent`, `QA_passed`, `low_priority`, etc.
- Apply based on PR context

**3. Size Label:**
- Always include the calculated size label: `size/xs`, `size/s`, `size/m`, `size/l`, or `size/xl`

### Example Label Selection Logic
```
Changed files: Fever/Features/Checkout/*.swift, FeverApp/Sources/Payment/*.swift
Commit messages: "Add Apple Pay support to checkout flow"

Selected labels:
- feature (change type)
- size/m (calculated size: 450 lines)
```

### Applying Labels
When creating the PR with `gh pr create`, pass multiple labels using a comma-separated format **with no spaces around the commas**:
```bash
--label "feature,size/m"
```

## iOS-Specific Considerations

When analyzing changes, pay special attention to:
- Swift version requirements
- iOS version compatibility
- New dependencies added to Package.swift
- UI changes requiring screenshots
- Accessibility considerations
- Performance implications
- New permissions required
- Dark mode compatibility
- Different device sizes (iPhone SE, standard, Plus/Max, iPad)
