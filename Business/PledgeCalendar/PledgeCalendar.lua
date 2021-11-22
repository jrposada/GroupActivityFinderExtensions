local GAFE = GroupActivityFinderExtensions

GAFE.PledgeCalendar = {}

function GAFE.PledgeCalendar.Init()
    local fragment = ZO_FadeSceneFragment:New(PledgeCalendarPanel)
    local priority = GAFE_ACTIVITY_FINDER_SORT_PRIORITY.PLEDGE_CALENDAR
    GROUP_MENU_KEYBOARD:AddCategory({
        priority = priority,
        name = "Pledge Calendar", -- translate
        categoryFragment = fragment,
        normalIcon = "esoui/art/journal/journal_tabicon_achievements_up.dds",
        pressedIcon = "esoui/art/journal/journal_tabicon_achievements_down.dds",
        mouseoverIcon = "esoui/art/journal/journal_tabicon_achievements_over.dds",
      })
end