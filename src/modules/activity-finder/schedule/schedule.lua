local GAFE = GroupActivityFinderExtensions
local WM = WINDOW_MANAGER

GAFE_SCHEDULE = {}

function GAFE_SCHEDULE.Init()
    local control = _G["GAFE_ActivitySchedulePanel"] or WM:CreateControlFromVirtual('GAFE_ActivitySchedulePanel', GuiRoot, "GAFE_ActivitySchedulePanel")
    local fragment = ZO_FadeSceneFragment:New(control)

    local priority = GAFE_ACTIVITY_FINDER_SORT_PRIORITY.ACTIVITY_SCHEDULE
    GROUP_MENU_KEYBOARD:AddCategory({
        priority = priority,
        name = GAFE.Loc("ActivitySchedule"),
        categoryFragment = fragment,
        normalIcon = "esoui/art/journal/journal_tabicon_cadwell_up.dds",
        pressedIcon = "esoui/art/journal/journal_tabicon_cadwell_down.dds",
        mouseoverIcon = "esoui/art/journal/journal_tabicon_cadwell_over.dds",
      })
end
