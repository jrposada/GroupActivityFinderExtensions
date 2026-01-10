# ESO Addon Compliance Audit

## Description

Analyzes ESO addon codebases against CLAUDE.md standards and conventions.

## How to Use

When triggered, perform the following analysis:

### 1. Read CLAUDE.md

First, read the CLAUDE.md file to understand the project standards.

### 2. Analyze Codebase

Review all .lua files in the repository and check:

- **File Structure Compliance**: 5-section structure (Localized Globals, Constants, Module Declaration, Private Functions, Public Functions, Module Registration)
- **Project Structure**: Directory organization matches expected layout
- **ESO Conventions**: Proper namespace usage, event handling, saved variables
- **Keyboard-Only**: No mouse-only interactions
- **Lua Best Practices**: Local variables, performance patterns, naming conventions, documentation

### 3. Report Format

Provide a structured report:

```
# CLAUDE.md Compliance Report

## Summary
- Overall Compliance: [X/10]
- Files Reviewed: [N]
- Critical Issues: [N]
- Warnings: [N]

## Critical Issues
[Must-fix violations of core standards]

## Warnings
[Should-fix recommendations]

## File-by-File Analysis
### filename.lua
- ✅ Compliant items
- ⚠️ Warnings
- ❌ Critical issues

## Migration Plan
[If structural changes needed, provide step-by-step refactoring approach]
```

### 4. Prioritization

Organize findings by:

- **High Priority**: Breaks functionality or violates critical ESO conventions
- **Medium Priority**: Doesn't follow CLAUDE.md structure but works
- **Low Priority**: Style/consistency improvements

## Output

Actionable, specific feedback with line references where possible.
