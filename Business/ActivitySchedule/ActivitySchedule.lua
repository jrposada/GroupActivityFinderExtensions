local GAFE = GroupActivityFinderExtensions

GAFE.ActivitySchedule = {}

function GAFE.ActivitySchedule.Init()
    local fragment = ZO_FadeSceneFragment:New(GAFE_ActivitySchedulePanel)
    local priority = GAFE_ACTIVITY_FINDER_SORT_PRIORITY.ACTIVITY_SCHEDULE
    GROUP_MENU_KEYBOARD:AddCategory({
        priority = priority,
        name = "Activity schedule", -- translate
        categoryFragment = fragment,
        normalIcon = "esoui/art/journal/journal_tabicon_achievements_up.dds",
        pressedIcon = "esoui/art/journal/journal_tabicon_achievements_down.dds",
        mouseoverIcon = "esoui/art/journal/journal_tabicon_achievements_over.dds",
      })
end