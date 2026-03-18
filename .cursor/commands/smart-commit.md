# Smart Commit Command

This command analyzes staged changes and creates a commit following the project's commit guidelines.

## How It Works

When you invoke this command (e.g., via `/smart-commit`), the AI will:

1. **Get the staged files** using `git diff --cached --name-only` or `git status`
2. **Analyze ONLY the staged changes** using `git diff --cached` - ignore unstaged changes
3. **Read the actual diff** to understand what changed in each staged file
4. **Identify the primary purpose** of the changes from the staged diff
5. **Choose the appropriate type** (feat, fix, refactor, etc.)
6. **Determine the scope** from file paths and changed components in staged files
7. **Write a clear subject line** following the commit guidelines
8. **Add a body** if the changes are complex or need explanation
9. **Include footer** if there are issue references or breaking changes
10. **Execute the commit** using `git commit -m` with the generated message

The entire process should be automated - analyze, generate, and commit without user intervention.

## Commit Guidelines

**IMPORTANT**: This command MUST follow the commit guidelines defined in `.feverrules/rules/commit-guidelines.md`. Please read and apply all guidelines from that file when generating commit messages.
