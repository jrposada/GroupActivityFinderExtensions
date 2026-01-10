### `/fix <filepath>` - Fix File Compliance

## Description

Analyzes a single file against CLAUDE.md standards and automatically fixes compliance issues while preserving functionality.

## When to Use

- After running `/audit` to fix specific files
- When creating new files that need structure cleanup
- Before committing code to ensure compliance
- User explicitly requests `/fix <filepath>`

## Prerequisites

- CLAUDE.md file must exist in the project root
- Target file must be a .lua file
- File path must be provided as argument

## Workflow

### Step 1: Read CLAUDE.md

Read the CLAUDE.md file from the project root to understand the project standards.

### Step 2: Analyze Target File

Analyze the file specified in `<filepath>` against:

- **File Structure Compliance**: 5-section structure (Localized Globals, Constants, Module Declaration, Private Functions, Public Functions, Module Registration)
- **ESO Conventions**: Proper namespace usage, event handling, saved variables
- **Keyboard-Only**: No mouse-only interactions
- **Lua Best Practices**: Local variables, performance patterns, naming conventions, documentation

### Step 3: Generate Corrected File

Create the fixed version with:

- Proper section organization (Localized Globals → Constants → Module Declaration → Private Functions → Public Functions → Module Registration)
- Localized global references for performance
- Consistent naming conventions
- Appropriate comments for complex logic
- Performance optimizations where obvious and safe

### Step 4: Provide Change Summary

````markdown
# 🔧 Fixed: <filepath>

## Changes Made

- ✅ Reorganized into 5-section structure
- ✅ Localized N global references
- ✅ Added missing constants section
- ✅ Fixed function naming (camelCase/snake_case)
- ✅ Added explanatory comments

## Before/After Comparison

**Before:**

```lua
[Key sections of original structure]
```

**After:**

```lua
[Key sections of new structure]
```

## Performance Improvements

- Reduced global lookups: X references → 0 (all localized)
- Cached API calls: [list specific calls]
- [Other optimizations]

## ⚠️ Manual Review Required

- Line XX: [Any assumptions made that need verification]
- Line YY: [Logic that was unclear and might need adjustment]
- [Any other items requiring human review]
````

### Step 5: Write Fixed File

- Use `str_replace` tool for targeted edits if changes are minimal
- Use `create_file` tool to write the complete fixed file
- **Important**: Always preserve the original file's functionality

### Step 6: Confirmation

- If changes are **substantial** (>30% of file modified), ask for confirmation before writing
- If changes are **minor** (<30% modified), apply automatically and report what was done
- Always show the change summary regardless of confirmation requirement

## Safety Guidelines

✅ **Do:**

- Preserve all functionality
- Keep original logic intact
- Only restructure and optimize
- Add helpful comments
- Flag uncertain changes for manual review

❌ **Don't:**

- Change business logic
- Remove functionality
- Make assumptions about intended behavior
- Introduce new dependencies
- Modify algorithm implementations

## Usage Examples

```
/fix src/main.lua
/fix src/modules/keybinds.lua
/fix src/modules/ui/dialogs.lua
```

## Output

- Change summary with specific improvements
- Complete fixed file
- List of items requiring manual review (if any)
- Confirmation of file write operation
