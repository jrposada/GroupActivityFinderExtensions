# Markdown to BBCode Converter for ESOUI/Minion

Convert the README.md file from Markdown format to BBCode format compatible with ESOUI addon descriptions and Minion.

## Conversion Rules

Apply these transformations in order:

### Headers

- `# Header 1` → `[size=6][b]Header 1[/b][/size]`
- `## Header 2` → `[size=5][b]Header 2[/b][/size]`
- `### Header 3` → `[size=4][b]Header 3[/b][/size]`
- `#### Header 4` → `[size=3][b]Header 4[/b][/size]`
- `##### Header 5` → `[b]Header 5[/b]`
- `###### Header 6` → `[b]Header 6[/b]`

### Text Formatting

- `**bold text**` or `__bold text__` → `[b]bold text[/b]`
- `*italic text*` or `_italic text_` → `[i]italic text[/i]`
- `***bold italic***` → `[b][i]bold italic[/i][/b]`
- `~~strikethrough~~` → `[s]strikethrough[/s]`
- `` `inline code` `` → `[font=monospace]inline code[/font]` or `[color=#d63031]inline code[/color]`

### Code Blocks

````
```language
code here
````

```
Transform to:
```

[code]
code here
[/code]

```

### Links
- `[link text](url)` → `[url=url]link text[/url]`
- `<url>` or bare URLs → `[url]url[/url]`

### Images
- `![alt text](image-url)` → `[img]image-url[/img]`
- With link: `[![alt](img-url)](link-url)` → `[url=link-url][img]img-url[/img][/url]`

### Lists
**Unordered lists:**
```

- Item 1
- Item 2
  - Nested item

```
Transform to:
```

[list]
[*]Item 1
[*]Item 2
[list][*]Nested item[/list]
[/list]

```

**Ordered lists:**
```

1. Item 1
2. Item 2

```
Transform to:
```

[list=1]
[*]Item 1
[*]Item 2
[/list]

```

### Quotes
```

> Quote text
> More quote text

```
Transform to:
```

[quote]
Quote text
More quote text
[/quote]

```

### Horizontal Rules
- `---`, `***`, or `___` → `[hr][/hr]` or simply remove (ESOUI may not support)

### Tables
Convert Markdown tables to formatted text using lists or code blocks, as BBCode tables are not universally supported:
```

| Header 1 | Header 2 |
| -------- | -------- |
| Cell 1   | Cell 2   |

```
Transform to:
```

[b]Header 1[/b] | [b]Header 2[/b]
Cell 1 | Cell 2

````
Or use [code] blocks for better formatting.

### Line Breaks
- Preserve double line breaks as paragraph separators
- Single line breaks within paragraphs should be preserved or converted to `<br>` if needed (though BBCode typically uses line breaks naturally)

### Special Considerations for ESOUI/Minion

1. **Remove or convert HTML**: If README contains HTML tags, convert them to BBCode equivalents or remove them
2. **Color codes**: ESOUI supports color tags: `[color=#hexcode]text[/color]`
3. **Size tags**: Use `[size=1]` to `[size=7]` for font sizes
4. **Center/align**: `[center]text[/center]`, `[left]text[/left]`, `[right]text[/right]`
5. **Spoilers**: `[spoiler]hidden text[/spoiler]` (if supported)
6. **Maximum length**: Check if there's a character limit for addon descriptions
7. **No script tags**: Remove any JavaScript or script content

### Preservation Rules

- Maintain the overall structure and hierarchy of the document
- Keep all content readable and properly formatted
- Preserve emphasis and important information
- Keep URLs functional and clickable
- Maintain code examples in readable format

## Output Format

Save the converted content to a file named `README.bbcode` or `DESCRIPTION.bbcode` in the `/mnt/user-data/outputs` directory.

The output should be:
- Clean and readable
- Compatible with ESOUI's BBCode parser
- Compatible with Minion addon manager
- Properly formatted with appropriate spacing
- Free of any unsupported BBCode tags

## Additional Processing

1. Remove any GitHub-specific badges or shields
2. Convert relative image paths to absolute URLs if needed
3. Simplify complex nested formatting if it causes issues
4. Test the output with a BBCode preview tool if possible
5. Ensure no malformed tags remain (all tags should be properly closed)

## Example Transformation

**Input (Markdown):**
```markdown
# My Awesome Addon

## Features
- Feature 1
- Feature 2

**Installation**: Download from [ESOUI](https://www.esoui.com)

```lua
local addon = {}
````

```

**Output (BBCode):**
```

[size=6][b]My Awesome Addon[/b][/size]

[size=5][b]Features[/b][/size]
[list]
[*]Feature 1
[*]Feature 2
[/list]

[b]Installation[/b]: Download from [url=https://www.esoui.com]ESOUI[/url]

[code]
local addon = {}
[/code]

```

---

Now process the README.md file and convert it to BBCode format following these rules.
```
