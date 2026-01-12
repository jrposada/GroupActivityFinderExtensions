## Getting started

- Create a PR against `master`.

### Add dungeon data

1. _In-game_ Get dungeon activity ID from Group & Activities Finder dungeon list.
1. _In-game_ Enable Achievements debug mode `/lpd achievements on`. With it enable clicking on a achievement on the Journal will log the id to console.
1. _In-game_ Enable Sets debug mode `/lpd sets on`. With it enable clicking on a set on the Collectables will log the id to console.
1. Use https://esoitem.uesp.net/viewlog.php to find unique skill point quest.
1. Add new activity IDs (normal and veteran) to `src/modules/activity-finder/activity-id.lua`
1. Add new set IDs to `src/modules/activity-finder/set-id.lua`
1. Add new entries to `src/modules/activity-finder/dungeons/dungeons-activity-data.lua`. You will need above data.

### Localization

Language files can be find at `src/lang`.

### Add pledge information

Not needed, this has been offloaded to LibUndauntedPledges library.
