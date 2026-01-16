# Group & Activity Finder Extensions

Enhances the Group & Activity Finder with quality-of-life improvements for daily pledges, trials, battlegrounds, and more. Designed for keyboard-friendly navigation and reduced clicking.

## Dependencies

- [LibAddonMenu-2.0](https://www.esoui.com/downloads/info7-LibAddonMenu.html)
- [LibPanicida](https://www.esoui.com/downloads/info4349-LibPanicida.html)
- [LibQuestData](https://www.esoui.com/downloads/info2625-LibQuestData.html)
- [LibSavedVars](https://www.esoui.com/downloads/info2161-LibSavedVars.html)
- [LibScroll](https://www.esoui.com/downloads/info1151-LibScroll.html)
- [LibUndauntedPledges](https://www.esoui.com/downloads/info3946-LibUndauntedPledges.html)

## Features

### Dungeon Finder Enhancements

- **Pledge Tracking**: See which daily pledges you've completed directly in the dungeon finder
- **Smart Queue Buttons**: Queue for dungeons based on:
  - Incomplete pledges
  - Missing dungeon quests
  - Missing item set collection pieces
  - Random dungeons at appropriate difficulty
- **Auto-Collapse**: Automatically collapses Normal/Veteran dungeon lists based on your preference or current group difficulty

### Trial Tracking

- Track trial quest completion status
- Monitor weekly chest availability with 7-day lockout timers
- View trial information directly in the activity finder

### Battleground Tracking

- Track daily battleground reward eligibility
- View completion status in the activity schedule

### Activity Schedule Panel

A dedicated panel accessible from the Group & Activity Finder showing:

- Daily activity completion status
- Pledge quest progress
- Trial availability and chest timers

### Queue Improvements

- **Queue Timer**: See how long you've been waiting in queue
- **Auto-Accept Ready Check**: Optionally auto-accept when a group is found (with configurable delay)
- **Sound Loop**: Looping notification sound while waiting for ready checks

### Quest Automation

- Auto-accept pledge quests from Undaunted NPCs
- Auto-complete and turn in pledges after dungeon completion
- Skip repetitive quest dialogue for daily content

### Map & Fast Travel

- Quick-travel buttons to major alliance cities on the world map
- Set a favorite fast travel location accessible via hotkey

### Armory Build Display

- Shows your currently active armory build on the character panel (Requires you to interact with the armory system to initialize. Just save or restore any build to get started)

### Currency Tracker

- Displays daily currency gains next to each currency in the Inventory Wallet
- Tracks gold, Alliance Points, Tel Var Stones, and other currencies
- Positive gains shown in green
- Automatically resets at daily reset
- Bank deposits/withdrawals are excluded from tracking

## Slash Commands

| Command | Description |
|---------|-------------|
| `/qp` | Queue for dungeons with incomplete pledges in your journal |
| `/qq` | Queue for dungeons with incomplete quests |
| `/qs` | Queue for dungeons with incomplete item set collections |
| `/qd` | Queue for a random dungeon |
| `/qb` | Queue for a random battleground |

## AI Assistance Notice

This addon was developed with the assistance of AI coding tools. All code has been reviewed and tested by human developers to ensure proper functionality within ESO.
