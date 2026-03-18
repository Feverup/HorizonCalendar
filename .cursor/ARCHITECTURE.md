# Fever Rules Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                         FEVER RULES SYSTEM                          │
└─────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────┐
│       .feverrules/               │  ← SINGLE SOURCE OF TRUTH
│                                  │     (Edit rules here only)
│  ├─ rules/                       │
│  │   └─ *.mdc                    │
│  ├─ commands/                    │
│  │   └─ *.md                     │
│  └─ *.md (root)                  │
└────────┬─────────────────────────┘
         │
         │ Run: make sync-rules
         │   or: python3 scripts/sync_rules.py
         │
         ▼
┌────────────────────────────────────────────────────────────────┐
│                    scripts/sync_rules.py                       │
│                                                                │
│  • Validates directories                                       │
│  • Reads .feverrules/rules/ and .feverrules/commands/          │
│  • Determines target locations                                 │
│  • Copies files to targets                                     │
│  • Reports sync status                                         │
└──────┬───────────────┬──────────────────────────┬──────────────┘
       │               │                          │
       ▼               ▼                          ▼
┌─────────────┐  ┌─────────────────┐   ┌──────────────────────────────────┐
│.cursor/     │  │.cursor/         │   │   .github/                       │
│ rules/      │  │ commands/       │   │                                  │
│  └─ *.mdc   │  │  └─ *.md        │   │  ├─ copilot-instructions.md      │
│             │  │                 │   │  │   (auto-generated)            │
│ (Cursor     │  │ (Cursor         │   │  ├─ instructions/                │
│  rules)     │  │  commands)      │   │  │   └─ *.instructions.md        │
└─────────────┘  └─────────────────┘   │  └─ PULL_REQUEST_TEMPLATE.md     │
                                       │                                  │
                                       │  (GitHub Copilot files)          │
                                       └──────────────────────────────────┘
```

## Data Flow

### 1. Creation/Update Flow

```
Developer
    │
    ├─► Edit .feverrules/rules/commit-guidelines.mdc
    │
    └─► Run: make sync-rules
            │
            ▼
        sync_rules.py
            │
            ├─► Copy to .cursor/rules/commit-guidelines.mdc
            │
            └─► Report: "✓ Synced: commit-guidelines.mdc"
```

### 2. File Type Routing

```
.feverrules/
    │
    ├─ rules/*.mdc ──────────────────► .cursor/rules/ (individual files)
    │   (Cursor AI rules)              .github/copilot-instructions.md (concatenated)
    │
    ├─ commands/*.md ────────────────► .cursor/commands/
    │   (Cursor commands)
    │
    ├─ instructions/*.instructions.md ► .github/instructions/
    │   (Path-specific Copilot)
    │
    └─ *.md (root files) ────────────► .github/
        (GitHub templates - flat)
        Examples:
        • PULL_REQUEST_TEMPLATE.md
```

## Component Details

### 1. Source Directory (`.feverrules/`)

**Purpose**: Single source of truth for all project rules

**Structure**:
```
.feverrules/
├── rules/                          # All rules (general + path-specific)
│   ├── commit-guidelines.mdc       → .cursor/rules/ + copilot-instructions.md
│   ├── pull-request-guidelines.mdc → .cursor/rules/ + copilot-instructions.md
│   └── model.instructions.md       → .github/instructions/ (path-specific)
├── commands/                       # Cursor commands
│   ├── smart-commit.md             → .cursor/commands/
│   └── smart-pr.md                 → .cursor/commands/
├── PULL_REQUEST_TEMPLATE.md        → .github/
└── README.md                       # This file
```

**Rules**:
- ✅ Always edit files here
- ❌ Never edit target directories directly
- ✅ All rules in `rules/` folder (both `.mdc` and `.instructions.md`)
- ✅ Commands in `commands/` folder
- ✅ Templates in root
- ✅ Only 2 folders: `rules/` + `commands/`

### 2. Sync Script (`scripts/sync_rules.py`)

**Purpose**: Automate copying rules to target locations

**Features**:
- Validates source and target directories
- Creates missing directories automatically
- Determines target location based on file type
- Skips unchanged files (optimization)
- Provides clear feedback
- Error handling and validation

**Algorithm**:
```python
for each file in .feverrules/:
    if file.extension == ".mdc":
        target = .cursor/rules/
    elif file.name == "PULL_REQUEST_TEMPLATE.md":
        target = .github/
    else:
        skip file

    if file content != target content:
        copy file to target
        report "Synced"
    else:
        report "Already up to date"
```

### 3. Target Directories

#### `.cursor/rules/`
- **Purpose**: Cursor AI rules for code assistance
- **File types**: `.mdc` files
- **Usage**: Cursor AI reads these for context
- **Source**: `.feverrules/rules/`
- **Managed by**: sync script (DO NOT EDIT)

#### `.cursor/commands/`
- **Purpose**: Custom Cursor commands
- **File types**: `.md` files
- **Usage**: Cursor command palette
- **Source**: `.feverrules/commands/`
- **Managed by**: sync script (DO NOT EDIT)

#### `.github/`
- **Purpose**: GitHub templates and Copilot configuration
- **File types**: Markdown files
- **Usage**: GitHub uses for PR creation and Copilot instructions
- **Source**: `.feverrules/` (root files and subdirectories)
- **Managed by**: sync script (DO NOT EDIT)
- **Structure**:
  - `copilot-instructions.md` - Auto-generated from all `rules/*.mdc` files
  - `instructions/*.instructions.md` - Path-specific instructions from `.feverrules/instructions/`
  - `PULL_REQUEST_TEMPLATE.md` - PR template from `.feverrules/`

## Sync Process Details

### Step-by-Step Execution

```
1. Validate Directories
   ├─ Check .feverrules/ exists
   ├─ Check/create .feverrules/rules/
   ├─ Check/create .feverrules/commands/
   ├─ Check/create .cursor/rules/
   ├─ Check/create .cursor/commands/
   └─ Check/create .github/

2. Discover Files
   ├─ Scan .feverrules/rules/ for *.mdc files
   ├─ Scan .feverrules/commands/ for *.md files
   ├─ Check .feverrules/ root for template files
   └─ Build (source, target) pairs

3. Sync Each File
   ├─ Read source content
   ├─ Read target content (if exists)
   ├─ Compare contents
   ├─ Copy if different
   └─ Report status

4. Summary
   ├─ Count successful syncs
   ├─ Count skipped files
   └─ Exit with status code
```

### File Type Mapping

| Source Pattern | Target Directory | Example |
|---------------|------------------|---------|
| `rules/*.mdc` | `.cursor/rules/` + `.github/copilot-instructions.md` | `rules/commit-guidelines.mdc` → `.cursor/rules/` + concatenated |
| `commands/*.md` | `.cursor/commands/` | `commands/smart-commit.md` → `.cursor/commands/smart-commit.md` |
| `instructions/*.instructions.md` | `.github/instructions/` | `instructions/viewmodel.instructions.md` → `.github/instructions/viewmodel.instructions.md` |
| `PULL_REQUEST_TEMPLATE.md` | `.github/` | `PULL_REQUEST_TEMPLATE.md` → `.github/PULL_REQUEST_TEMPLATE.md` |
| `README.md` | (skipped) | Documentation only |

## Usage Patterns

### Pattern 1: Update Existing Rule

```bash
# 1. Edit source
vim .feverrules/rules/commit-guidelines.mdc

# 2. Sync
make sync-rules

# 3. Verify
git diff .cursor/rules/commit-guidelines.mdc

# 4. Commit
git add .feverrules/ .cursor/
git commit -m "[TICKET] docs: update commit guidelines"
```

### Pattern 2: Add New Rule

```bash
# 1. Create new rule
cat > .feverrules/rules/new-rule.mdc << 'EOF'
---
description: New rule description
alwaysApply: false
---
# New Rule
...
EOF

# 2. Sync
make sync-rules

# 3. Commit
git add .feverrules/ .cursor/
git commit -m "[TICKET] docs: add new rule"
```

### Pattern 3: Add New Command

```bash
# 1. Create new command
cat > .feverrules/commands/new-command.md << 'EOF'
# New Command Description
...
EOF

# 2. Sync
make sync-rules

# 3. Commit
git add .feverrules/ .cursor/
git commit -m "[TICKET] docs: add new command"
```

### Pattern 4: Bulk Update

```bash
# 1. Edit multiple files
vim .feverrules/rules/commit-guidelines.mdc
vim .feverrules/rules/pull-request-guidelines.mdc

# 2. Sync all at once
make sync-rules

# 3. Review all changes
git diff .cursor/

# 4. Commit together
git add .feverrules/ .cursor/
git commit -m "[TICKET] docs: update multiple rules"
```

## Error Handling

### Missing Source Directory
```
❌ Error: Source directory not found: .feverrules
```
**Solution**: Create `.feverrules/` directory

### Permission Issues
```
❌ Error syncing file.mdc: Permission denied
```
**Solution**: Check file permissions

### No Files to Sync
```
⚠️  No files found to sync in .feverrules
```
**Solution**: Add `.mdc` or template files

## Extension Points

### Adding New Target Directories

To add support for new target directories, modify `sync_rules.py`:

```python
def get_files_to_sync(self) -> List[Tuple[Path, Path]]:
    # ... existing code ...

    # Add new target
    elif file_path.name == "NEW_TEMPLATE.md":
        target_path = self.new_target_dir / file_path.name
        files_to_sync.append((file_path, target_path))
```

### Adding New File Types

```python
# In __init__
self.new_target_dir = project_root / ".newtarget"

# In get_files_to_sync
elif file_path.suffix == ".newext":
    target_path = self.new_target_dir / file_path.name
    files_to_sync.append((file_path, target_path))
```

## Best Practices

1. **Always use the sync script** - Never manually copy files
2. **Commit atomically** - Source and targets together
3. **Verify after sync** - Check git diff before committing
4. **Document changes** - Use clear commit messages
5. **Test locally** - Run sync before pushing

## Troubleshooting

### Sync not updating files

**Check**:
```bash
# Compare files manually
diff .feverrules/commit-guidelines.mdc .cursor/rules/commit-guidelines.mdc
```

**Solution**: Ensure you saved the source file

### Files out of sync

**Check**:
```bash
# Run sync with verbose output
python3 scripts/sync_rules.py
```

**Solution**: Re-run sync script

### Git shows unexpected changes

**Check**:
```bash
# View what changed
git diff .cursor/rules/
```

**Solution**: Review changes and commit if correct

## Performance Considerations

- **File comparison**: Script compares content before copying (efficient)
- **Skips unchanged**: Only copies when content differs
- **Fast execution**: Typically completes in < 1 second
- **Scalable**: Can handle dozens of rules without issues

## Security Considerations

- Source files are plain text (no secrets)
- Sync script only reads/writes local files
- No network operations
- Safe to run in CI/CD pipelines

## Future Enhancements

Potential improvements:
- [ ] Dry-run mode (`--dry-run`)
- [ ] Verbose mode (`--verbose`)
- [ ] Watch mode (auto-sync on file change)
- [ ] Validation of rule syntax
- [ ] Pre-commit hook integration
- [ ] Backup before sync
