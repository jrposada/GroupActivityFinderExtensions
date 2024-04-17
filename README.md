**READ BEFORE INSTALL**

The amount of time and effort I put into the addon is directly related to the amount of time I play the game. I am a casual player, meaning I can go for a long time without playing (years in fact) and the addon **will not be updated during those times**. This type of addon requires updates each patch to support new dungeons and stuff. If you still want to give it a try you are more than welcome to do so. Have fun!

# Summary

Adds a extra functionality around vanilla Group & Activity Finder and other in-game activities.

**Notice:** By default, when choosing between Normal and Veteran content, the group current group setting will be used (selected on the "Group" tab of the "Group & Activity Finder" panel). This behavior can be changed through the settings to always use Normal, Veteran or current group setting.

**Notice:** Controller is not supported.

## Dependencies

- [LibAddonMenu-2.0](https://www.esoui.com/downloads/info7-LibAddonMenu.html)
- [LibSavedVars](https://www.esoui.com/downloads/info2161-LibSavedVars.html)
- [LibQuestData](https://www.esoui.com/downloads/info2625-LibQuestData.html)
- [LibScroll](https://www.esoui.com/downloads/info1151-LibScroll.html)

## Supported languages

- English
- French
- German
- Russian

# Features

## Activity Finder

- Group
- Random dungeon
- Random battleground
- Dungeons
- Trials (Removed)
- Schedules
- Auto confirm

## Map

- Alliance capitals Wayshrines.

  Added shortcuts to all three Alliance capitals to map view. Always visible on above filters panel.

- TP to favorite Wayshrine on map hotkey.

  Added new active binding to map view to TP to user selected Wayshrine. Favorite can be change in the addon settings.

## Quest Automation

Automatically accepts and complete any daily quests when interacting with the quest giver. This will also close the conversation at the end.

**Notice:** to avoid conflicts with other addons it ignore daily writs.

# Commands

[SIZE="4"]Features[/SIZE]

[LIST]
Auto confirm
[/LIST]
Automatically accept activity finder queues. This option can be disabled in the setting menu.
[LIST]
Auto accept pledges quests
[/LIST]
Automatically takes and accept pledges quest when talking to the quest giver. NOTE: Finishing the quest still has to be done manually (work in progress)
[LIST]
Check Active Pledges
[/LIST]
Adds a button to check all dialy pledges for which the player has the mission. There is an option to remove this button and select them on menu open. Note: It uses the current dungeon mode to select either normal or veteran version of the dungeons.
[LIST]
Check missing quests
[/LIST]
Adds a button to check all the dungeons for which the user has not done the quest yet (and has not gotten the skill point).
[LIST]
Check missing sets
[/LIST]
Adds a button to check all the dungeons for which the user has not collected all drop sets.
[LIST]
Adds more info to the dungeons list:
[LIST]
Dungeon Wayshrine
[/LIST]
[LIST]
All sets collected.
[/LIST]
[LIST]
Dungeon Completion Achivement
[/LIST]
[LIST]
Quest Completion
[/LIST]
[LIST]
Hardmode Achivement
[/LIST]
[LIST]
Speedrun Achivement
[/LIST]
[LIST]
No Death Achivement
[/LIST]
[/LIST]
[LIST]
Trials Finder:
New tab to help look for trials groups. It offers:
[LIST]
Trail wayshrine
[/LIST]
[LIST]
Weekly chest timer
[/LIST]
[LIST]
Achievements (only for AA, HRC and SO, rest is in progress)
[/LIST]
[LIST]
Look for more button. Given the desire group roles set up, calculate the missing roles and writes them to chat with a LFM <trial> xT xH xDD pattern
[/LIST]
[LIST]
Look for group button. Writes a message with the pattern <rol> LFG <trial>
[/LIST]
[LIST]
Look for group and Look for more messages now support '+1-3' modifier.
[/LIST]
[/LIST]
[LIST]
Capitals waysrhine
[/LIST]
[LIST]
Queue timer. Displays current queue time next to the status in the main window.
[/LIST]
[LIST]
Dungeon and battleground premium reward timer. Shows how long until the next premium rewards is available. (Timer can be manually reset in settings).
[/LIST]
[LIST]
Schedule:
[/LIST]
Shows tracked dailies and pledges for all characters.

[SIZE="4"]Commands[/SIZE]
[LIST]/gafe[/LIST]
Displays all available commands
[LIST]/gafequests[/LIST]
Queue for all available pledges
[LIST]/gafequests verbose[/LIST]
Queue for all available pledges and log all the information.

# How to

## Add new Dungeon

1. Enable addon developer mode on settings.
2. Get the activity id from in-game dungeon finder. If the activity is unknown it should display a "TODO XXX" message on the specific activities list.
3. Add new id to `activity-id.lua`. Each activity has two entries: normal and veteran. Keep the same order as in the in-game list in english for consistency.
4. Add new dungeon pledge to `pledge-id.lua`. Value is pledge quest id.
5. Add new pledge id to `pledge-list.lua`. Add it to the end of the list corresponding npm list. Remember to adjust the shift value to match the calendar on [ESO-HUB](https://eso-hub.com/en/daily-undaunted-pledges).
6. Add new dungeon sets to `set-id.lua`. To extract the set names and ids go to in-game sets panel and toggle the set you need. This will log the set name and id in the chat.
7. Add new dungeon activity data to `dungeons-activity-data.lua`.
   1. Quests ids: http://esoitem.uesp.net/viewlog.php?record=uniqueQuest
   2. Achievements: use debug mode to log ids to chat.

## Add new Trial
