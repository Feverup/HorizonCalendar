# Fever Rules - Centralized Rule Management

This directory contains the **source of truth** for all project rules and templates that are used across different tools and platforms.

## 📁 Directory Structure

```
.feverrules/                         (SOURCE OF TRUTH - EDIT HERE)
├── rules/                           → .cursor/rules/ + .github/
│   ├── *.mdc                        → .cursor/rules/ + copilot-instructions.md (concatenated)
│   └── *.instructions.md            → .github/instructions/ (path-specific)
├── commands/                        → .cursor/commands/
│   ├── smart-commit.md
│   └── smart-pr.md
├── PULL_REQUEST_TEMPLATE.md         → .github/PULL_REQUEST_TEMPLATE.md
└── README.md                        (this file)
```

## 🎯 Purpose

The `.feverrules` directory serves as a centralized location for maintaining project rules. Instead of manually updating rules in multiple locations (`.cursor/rules/`, `.github/`, etc.), you only need to update them here and run the sync script.

## 🔄 How It Works

1. **Edit rules** in `.feverrules/` directory
2. **Run sync script** to propagate changes:
   ```bash
   python3 scripts/sync_rules.py
   ```
3. **Commit changes** to both `.feverrules/` and target directories

## 📝 File Types & How They Sync

### Rules Folder (`rules/`)

The `rules/` folder contains **all** types of rules:

#### General Rules (`rules/*.mdc`)
Files with `.mdc` extension are general Cursor AI rules.

**Syncs to:**
- ✅ `.cursor/rules/` - Individual files (for Cursor IDE)
- ✅ `.github/copilot-instructions.md` - Concatenated (for GitHub Copilot)

**Current rules:**
- `rules/commit-guidelines.mdc` - Commit message conventions
- `rules/pull-request-guidelines.mdc` - PR creation guidelines

**When you add a new rule:**
1. Add `.mdc` file to `.feverrules/rules/`
2. Run `make sync-rules`
3. Auto-appears in `.cursor/rules/` AND `.github/copilot-instructions.md`

#### Path-Specific Instructions (`rules/*.instructions.md`)
Files with `.instructions.md` extension are path-specific GitHub Copilot instructions.

**Syncs to:**
- ✅ `.github/instructions/` - Path-specific (GitHub Copilot only)

**How it works:**
- Use frontmatter with `applyTo` glob pattern
- Applies ONLY to files matching the pattern
- NOT concatenated into copilot-instructions.md

**Current instructions:**
- `rules/model.instructions.md` - Modern @Perceptible pattern for Models
  - `applyTo: "FeverApp/Sources/**/*Model.swift"`

**Example:**
```markdown
---
applyTo: "FeverApp/Sources/**/*Repository.swift"
---

# Repository Guidelines
...
```

### Cursor Commands (`commands/*.md`)
Markdown files in the `commands/` subdirectory define custom Cursor commands.

**Syncs to:**
- ✅ `.cursor/commands/` - Individual files (for Cursor IDE)

**Current commands:**
- `commands/smart-commit.md` - Smart commit command
- `commands/smart-pr.md` - Smart PR creation command

### GitHub Templates (root files)
Templates in the root of `.feverrules/` that sync to `.github/`.

**Current templates:**
- `PULL_REQUEST_TEMPLATE.md` - Template for pull requests

## 🛠️ Sync Script

The sync script (`scripts/sync_rules.py`) automatically:
- ✅ **Auto-generates** `.github/copilot-instructions.md` by concatenating all `rules/*.mdc` files
- ✅ Copies `rules/*.mdc` files to `.cursor/rules/` (individual files)
- ✅ Copies `commands/*.md` files to `.cursor/commands/`
- ✅ Copies `instructions/*.instructions.md` files to `.github/instructions/` (path-specific)
- ✅ Copies `PULL_REQUEST_TEMPLATE.md` to `.github/`
- ✅ Validates that required directories exist
- ✅ Creates missing directories if needed
- ✅ Skips files that are already up to date
- ✅ Provides clear feedback on what was synced

### Usage

```bash
# Using Make (recommended)
make sync-rules

# Or directly with Python
python3 scripts/sync_rules.py
```

### Output Example

```
Project root: /Users/ibrahim.koteish@feverup.com/Documents/fever/iOS

🔄 Starting rules sync...

📝 Generating .github/copilot-instructions.md from rules...
✓ Generated: copilot-instructions.md (auto-generated from 2 rule(s))

Found 5 file(s) to sync

✓ Already up to date: .cursor/rules/commit-guidelines.mdc
✓ Already up to date: .cursor/rules/pull-request-guidelines.mdc
✓ Already up to date: .cursor/commands/smart-commit.md
✓ Already up to date: .cursor/commands/smart-pr.md
✓ Already up to date: .github/PULL_REQUEST_TEMPLATE.md

============================================================
Sync complete: 5/5 files synced successfully
✓ Generated 1 file (copilot-instructions.md)
============================================================
```

## 📋 Adding New Rules

To add a new rule:

1. **Create the file** in `.feverrules/rules/`:
   ```bash
   vim .feverrules/rules/new-rule.mdc
   ```

2. **Run the sync script**:
   ```bash
   make sync-rules
   ```

3. **Result**:
   - ✅ Copied to `.cursor/rules/new-rule.mdc`
   - ✅ Auto-included in `.github/copilot-instructions.md`

4. **Commit**:
   ```bash
   git add .feverrules/ .cursor/ .github/
   git commit -m "[TICKET] docs: add new rule"
   ```

## 🔍 Workflow Examples

### Updating Existing Rules

```bash
# 1. Edit the rule in .feverrules/rules/
vim .feverrules/rules/commit-guidelines.mdc

# 2. Sync to target directories
make sync-rules

# 3. Verify changes
git diff .cursor/rules/commit-guidelines.mdc
git diff .github/copilot-instructions.md

# 4. Commit
git add .feverrules/ .cursor/ .github/
git commit -m "[TICKET] docs: update commit guidelines"
```

### Adding New Rules

```bash
# 1. Create new rule file
cat > .feverrules/rules/code-style.mdc << 'EOF'
---
description: Code style guidelines for Swift development
alwaysApply: false
---
# Code Style Guidelines
...
EOF

# 2. Sync (auto-generates copilot-instructions.md)
make sync-rules

# 3. Commit
git add .feverrules/ .cursor/ .github/
git commit -m "[TICKET] docs: add code style guidelines"
```

### Adding New Commands

```bash
# 1. Create new command
vim .feverrules/commands/new-command.md

# 2. Sync
make sync-rules

# 3. Commit
git add .feverrules/ .cursor/
git commit -m "[TICKET] docs: add new command"
```

### Adding Path-Specific Instructions

```bash
# 1. Create instruction file in rules/ folder with frontmatter
cat > .feverrules/rules/repository.instructions.md << 'EOF'
---
applyTo: "FeverApp/Sources/**/*Repository.swift"
---

# Repository Guidelines
- Use protocol-based design
- Handle errors appropriately
...
EOF

# 2. Sync
make sync-rules

# 3. Commit
git add .feverrules/ .github/
git commit -m "[TICKET] docs: add repository instructions"
```

## ⚠️ Important Notes

1. **Always edit in `.feverrules/`**: Never edit files directly in `.cursor/rules/` or `.github/` as they will be overwritten by the sync script.

2. **`.github/copilot-instructions.md` is auto-generated**: This file is automatically created by concatenating all `rules/*.mdc` files. Don't edit it manually!

3. **Run sync before committing**: Always run `make sync-rules` after making changes to ensure all target directories are up to date.

4. **Commit all changes together**: When you update a rule, commit both `.feverrules/`, `.cursor/`, and `.github/`.

5. **Check sync output**: The sync script tells you which files were updated and which were already up to date.

## 🚀 Benefits

- ✅ **Single source of truth**: All rules in `.feverrules/rules/` and `.feverrules/commands/`
- ✅ **Auto-generation**: `.github/copilot-instructions.md` auto-generated from rules
- ✅ **Consistency**: Same rules work in Cursor and GitHub Copilot
- ✅ **Easy updates**: Add new rule → run sync → done
- ✅ **Version control**: Track all rule changes in git
- ✅ **No manual copying**: Script handles everything

## 🔗 Related Files

- **Source**: `.feverrules/` (edit here)
- **Sync Script**: `scripts/sync_rules.py`
- **Targets**: `.cursor/` and `.github/` (auto-synced)
- **Command**: `make sync-rules`

## 📚 Further Reading

- [Cursor Documentation](https://cursor.sh/docs)
- [GitHub Copilot Instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions)
- Main project README: `../README.md`
