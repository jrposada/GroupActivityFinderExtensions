# Localize command

## Description

Synchronizes and translates language files using `en.lua` as the authoritative source. Ensures all target language files have the same keys in the same order, with appropriate ESO-specific translations.

## When to Use

- After adding new strings to `en.lua`
- To synchronize key order across all language files
- User explicitly requests `/localize`

## Source and Target Files

- **Source**: `src/lang/en.lua` (authoritative)
- **Targets**: `src/lang/de.lua`, `src/lang/fr.lua`, `src/lang/ru.lua`, `src/lang/es.lua`

## Workflow

### Step 1: Read Source File

Read `src/lang/en.lua` and extract:
- All localization keys in their exact order
- English values for each key

### Step 2: Read Target Files

For each target language file (`de.lua`, `fr.lua`, `ru.lua`, `es.lua`):
- Extract existing translations
- Compare keys against source to find:
  - **Missing keys**: Present in en.lua but not in target (need translation)
  - **Orphaned keys**: Present in target but not in en.lua (should be removed)

### Step 3: Analyze and Report

Generate a report showing for each language:
- Count of missing keys that need translation
- Count of orphaned keys to be removed
- List the specific keys in each category

### Step 4: Translate Missing Keys

For each missing key, translate from English following these guidelines:

#### Translation Guidelines

1. **ESO Official Names** - Use official in-game translations for:
   - Trial names (e.g., "Sunspire" → DE: "Sonnspitz", FR: "Sollance", RU: "Солнечный Шпиль")
   - Dungeon names
   - Location names
   - Game terminology (Pledges, Veteran, etc.)

2. **UI Text** - Translate naturally for the target language:
   - Keep translations concise (UI space is limited)
   - Maintain the same tone as English
   - Use ESO community conventions where applicable

3. **Special Syntax** - Preserve exactly:
   - Placeholders: `<<1>>`, `<<2>>`, etc.
   - Plural forms: `<<1[singular/plural/plural2]>>` - translate ONLY the words inside brackets
   - Example: `<<1[Today/In $d day/In $d days]>>`
     - DE: `<<1[Heute/In $d Tag/In $d Tagen]>>`
     - FR: `<<1[Aujourd'hui/En $d jour/Dans $d jours]>>`
     - RU: `<<1[Сегодня/Через $d день/через $d дня]>>`

4. **Debug/Technical Strings** - Keep in English:
   - `Debug_*` prefixed keys
   - Technical identifiers
   - Addon names (e.g., "PerfectPixel", "TamrielTradeCentre")

5. **Untranslatable Content** - Keep original English value if:
   - It's a proper noun without official ESO translation
   - It's a technical term with no standard translation

### Step 5: Generate Updated Files

For each target language file, generate the complete updated file:

```lua
local GAFE = GroupActivityFinderExtensions

GAFE.lang = "<langcode>"
GAFE.Localization = {
  -- Keys in EXACT same order as en.lua
  KeyOne = "Translated value",
  KeyTwo = "Another translation",
}
```

**Key Ordering Rules:**
- Keys MUST appear in the exact same order as `en.lua`
- Alphabetical order within the `Localization` table (matching en.lua)
- Two-space indentation for table entries
- No trailing comma on last entry (match en.lua style)
- One blank line at end of file

### Step 6: Write Files and Report

Write each updated language file and provide a summary:

```markdown
# Localization Sync Complete

## Changes by Language

### German (de.lua)
- Added: N new keys
- Removed: N orphaned keys

**New translations:**
| Key | English | German |
|-----|---------|--------|
| NewKey | "English text" | "German text" |

### French (fr.lua)
...

### Russian (ru.lua)
...

## Keys Kept in English
- `Debug_NotQueuedList`: Debug string (intentionally English)
```

## Translation Quality Guidelines

### German (de)
- Use formal "Sie" form sparingly, prefer neutral phrasing
- ESO uses specific German terms (Verlies = Dungeon, Prüfung = Trial)
- Compound words are common and correct

### French (fr)
- Use appropriate accents (é, è, ê, à, etc.)
- ESO French uses specific terms (Épreuve = Trial, Donjon = Dungeon)
- Gender agreement is important

### Russian (ru)
- Use Cyrillic script
- ESO Russian has official translations for most content
- Declension matters for grammatical correctness

## Safety Guidelines

**DO:**
- Preserve all existing good translations
- Keep special syntax intact (`<<1>>`, etc.)
- Use official ESO translations when available
- Match key order exactly to en.lua

**DON'T:**
- Overwrite existing translations
- Change the structure of placeholder syntax
- Translate proper nouns without official sources

## Usage

```
/localize
```

No arguments needed - always processes all language files against en.lua source.

## Output

- Updated language files with synchronized keys and order
- Summary of changes per language
- Table showing new translations added
