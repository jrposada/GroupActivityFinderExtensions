Adds a bit of extra functionality and info to the Group & Activity Finder UI

[B]IMPORTANT:[/B] This addon use ZOS Dungeon Mode to decide which activities to choose. This means that if you have normal selected only normal activities will be selected. On the other hand if you have veteran selected only veteran activities will be selected. To change the Dungeon Mode go open the Group & Activity Finder, select the Group tab and on the top of the window you will see the Dungeon Mode selection UI

Currently it does not support controller.

[SIZE="4"]Dependencies[/SIZE]
[LIST]LibAddonMenu[/LIST]
[LIST]LibScroll[/LIST]

[SIZE="4"]Supported languages[/SIZE]
[LIST]English[/LIST]
[LIST]French[/LIST]
[LIST]German [/LIST]
[LIST]Russian[/LIST]

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
4. Add new dungeon pledge to `pledge-id.lua`. For the value just increase the count as is an internal id.
5. Add new pledge id to `pledge-list.lua`. Add it to the end of the list corresponding npm list. Remember to adjust the shift value to match the calendar on [ESO-HUB](https://eso-hub.com/en/daily-undaunted-pledges).
6. Add new dungeon sets to `set-id.lua`. To extract the set names and ids go to in-game sets panel and toggle the set you need. This will log the set name and id in the chat.
7. Update `GAFE_DUNGEON_PLEDGE_QUEST_NAME` variable on lang files with the new pledge quest name. It have to match the exact in game name on the journal.
8. Add new dungeon activity data to `dungeons-activity-data.lua`.
   1. Quests ids: http://esoitem.uesp.net/viewlog.php?record=uniqueQuest
   2. Achievements: use debug mode.

## Add new Trial
TODO

```
TODO implement LibQuestData
local LQD = LibQuestData
function lib:get_quest_giver(id, lang)
  lang = lang or lib.effective_lang
  return lib.quest_givers[lang][id]
end

function lib:get_quest_name(id, lang)
  local unknown = lib.unknown_quest_name_string[lib.effective_lang]
  lang = lang or lib.effective_lang
  return lib.quest_names[lang][id] or unknown
end
```