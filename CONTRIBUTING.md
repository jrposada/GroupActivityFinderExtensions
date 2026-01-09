# How to

## Add new Dungeon

1. Enable addon's developer mode.
2. Get the activity id from in-game dungeon finder. If the activity is unknown it should display a "TODO XXX" message on the specific activities list.
3. Add new id to `activity-id.lua`. Each activity has two entries: normal and veteran. Keep the same order as in the in-game list in english for consistency.
4. Add new dungeon pledge to `pledge-id.lua`. Value is pledge quest id.
5. Add new pledge id to `pledge-list.lua`. Add it to the end of the list corresponding npm list. Remember to adjust the shift value to match the calendar on [ESO-HUB](https://eso-hub.com/en/daily-undaunted-pledges).
6. Add new dungeon sets to `set-id.lua`. To extract the set names and ids go to in-game sets panel and toggle the set you need. This will log the set name and id in the chat.
7. Add new dungeon activity data to `dungeons-activity-data.lua`.
   1. Quests ids: http://esoitem.uesp.net/viewlog.php?record=uniqueQuest
   2. Achievements: use debug mode to log ids to chat.
