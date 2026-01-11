local GAFE = GroupActivityFinderExtensions
local WM = WINDOW_MANAGER

GAFE_SCHEDULE = {}

local ZO_ACTIVITY_FINDER_SORT_PRIORITY = ZO_ACTIVITY_FINDER_SORT_PRIORITY

local BASE_DUNGEONS_PRIORITY = ZO_ACTIVITY_FINDER_SORT_PRIORITY.DUNGEONS
local ACTIVITY_PRIORITY = BASE_DUNGEONS_PRIORITY + 1000

function GAFE_SCHEDULE.Init()
  local control = _G["GAFE_ActivitySchedulePanel"] or
      WM:CreateControlFromVirtual('GAFE_ActivitySchedulePanel', GuiRoot,
        "GAFE_ActivitySchedulePanel")
  local fragment = ZO_FadeSceneFragment:New(control)
  GROUP_MENU_KEYBOARD:AddCategory({
    priority = ACTIVITY_PRIORITY,
    name = GAFE.Loc("ActivitySchedule"),
    categoryFragment = fragment,
    normalIcon = "esoui/art/journal/journal_tabicon_cadwell_up.dds",
    pressedIcon = "esoui/art/journal/journal_tabicon_cadwell_down.dds",
    mouseoverIcon = "esoui/art/journal/journal_tabicon_cadwell_over.dds",
  })
end
