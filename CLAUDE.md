# ESO Addon Development Guide

## Project Overview

This is an Elder Scrolls Online (ESO) addon focused on keyboard-only accessibility and usability. All code must follow Lua best practices and ESO addon conventions.

## Core Technologies

- **Language**: Lua 5.1 (ESO uses Lua 5.1)
- **UI Framework**: ESO's XML-based UI system
- **Platform**: Elder Scrolls Online addon API

## Coding Standards

### Lua Best Practices

- Use local variables whenever possible for performance
- Avoid global namespace pollution - prefix globals with addon name
- Comment complex logic and non-obvious code
- Use triple-dash (`---`) for all function documentation comments
- Handle nil values defensively
- Use `pairs()` for tables, `ipairs()` for arrays

### Documentation Standards

**Function Documentation:**

- Always use triple-dash (`---`) notation for function documentation
- Include description of what the function does
- Document all parameters with `@param` tags
- Document return values with `@return` tags
- Follow LuaDoc/LDoc conventions

**Example:**

```lua
--- Event handler for addon loaded event.
--- Initializes the addon when it is fully loaded.
--- @param eventCode number The event code
--- @param addonName string The name of the addon that was loaded
local function onAddOnLoaded(eventCode, addonName)
    -- implementation
end

--- Calculates the next daily reset time.
--- @return number timestamp The Unix timestamp of next reset
function Module.GetNextReset()
    return calculateDailyReset()
end
```

**Inline Comments:**

- Use double-dash (`--`) for inline comments
- Use for explaining complex logic or non-obvious behavior
- Keep comments concise and relevant

**Example:**

```lua
-- Cache frequently used globals for performance
local EVENT_MANAGER = EVENT_MANAGER
local GetTimeStamp = GetTimeStamp

local SECONDS_PER_DAY = 86400  -- Used for daily reset calculations
```

**Comment Guidelines:**

- Write comments that explain _why_, not _what_ (code should be self-documenting for "what")
- Update comments when code changes
- Remove outdated or redundant comments
- Use TODO/FIXME/NOTE prefixes for special comments

### ESO Addon Conventions

- **Namespace**: Use a single global table for your addon (e.g., `MyAddon = {}`)
- **Manifest File**: Always include addon metadata in `.addon` manifest
- **Event Registration**: Register for ESO events properly using `EVENT_MANAGER`
- **Saved Variables**: Use `ZO_SavedVars` for persistent data
- **UI Elements**: Prefix UI control names with addon identifier

### Project Structure

```
AddonName/
├── AddonName.addon        # Manifest file
├── src/                   # Addon source code
│   ├── main.lua           # Main addon initialization
│   ├── lang/              # Localization files
│   └── modules/           # Feature modules (may include .xml files)
└── scripts/               # DevOps/Developer scripts
```

**Note**: XML UI files are co-located with their corresponding feature modules when applicable.

### File Structure Standard

All Lua files must follow this 5-section structure (in order):

1. **Localized Globals** - Cache global references for performance

```lua
   local EVENT_MANAGER = EVENT_MANAGER
   local GetTimeStamp = GetTimeStamp
   local math_floor = math.floor
```

2. **Constants** - Define module-level constants

```lua
   local SECONDS_PER_DAY = 86400
   local MAX_RETRY_ATTEMPTS = 3
```

3. **Module Declaration** - Export table declaration

```lua
   local Module = {}
```

4. **Private Functions** - Internal helper functions

```lua
   local function calculateDailyReset()
       -- implementation
   end
```

5. **Public Functions** - Exported API functions

```lua
   function Module.GetNextReset()
       return calculateDailyReset()
   end
```

6. **Module Registration** _(if applicable)_ - Hook to main addon namespace

```lua
   MyAddon.Module = Module
```

**Rationale**: Localizing globals reduces table lookup overhead and improves performance in Lua, which is critical for ESO addons running in a real-time game environment.

## Performance Considerations

- Minimize event handler overhead
- Cache frequently used API calls
- Avoid unnecessary table creation in loops
- Use object pools for frequently created/destroyed objects
- Throttle or debounce high-frequency events

## When Providing Code

- Include complete, runnable examples when possible
- Show both .lua and .xml files when UI is involved
- Explain ESO-specific API calls
- Point out potential performance pitfalls
- Suggest keyboard navigation patterns

## Resources to Reference

- [ESO source code](https://github.com/esoui/esoui)
- [ESO Lua API Wiki](https://wiki.esoui.com/Main_Page)
