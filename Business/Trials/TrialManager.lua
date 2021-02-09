-- Replicates esoui\ingame\lfg\zo_battlegroundfinder_manager.lua
local GAFE = GroupActivityFinderExtensions

local categoryData = 
{
    keyboardData =
    {
        name = GAFE.Loc("TrailsCategoryHeader"),
        normalIcon = "EsoUI/Art/LFG/LFG_indexIcon_battlegrounds_up.dds",
        pressedIcon = "EsoUI/Art/LFG/LFG_indexIcon_battlegrounds_down.dds",
        mouseoverIcon = "EsoUI/Art/LFG/LFG_indexIcon_battlegrounds_over.dds",
    },

    gamepadData = -- TODO: Understand
    {
        name =GAFE.Loc("TrailsCategoryHeader"),
        menuIcon = "EsoUI/Art/LFG/Gamepad/LFG_menuIcon_battlegrounds.dds",
        sceneName = "gamepadBattlegroundFinder",
        tooltipDescription = GAFE.Loc("TrailsCategoryHeader"),
    },
    priority = 500 -- ZO_ACTIVITY_FINDER_SORT_PRIORITY
}

local TrialFinder_Manager = ZO_ActivityFinderTemplate_Manager:Subclass()

function TrialFinder_Manager:New(...)
    return ZO_ActivityFinderTemplate_Manager.New(self, ...)
end

function TrialFinder_Manager:Initialize()
    local filterModeData = ZO_ActivityFinderFilterModeData:New(LFG_ACTIVITY_TRIAL)
    filterModeData:SetSubmenuFilterNames(GAFE.Loc("TrialsSpecificFilterText"))
    ZO_ActivityFinderTemplate_Manager.Initialize(self, "GAFE_TrialFinder", categoryData, filterModeData)

    self:SetLockingCooldownTypes(LFG_COOLDOWN_DUNGEON_REWARD_GRANTED)

    TRIAL_FINDER_KEYBOARD = self:GetKeyboardObject()
    TRIAL_FINDER_GAMEPAD = self:GetGamepadObject()
    GAMEPAD_TRIAL_FINDER_SCENE = TRIAL_FINDER_GAMEPAD:GetScene()
end

function TrialFinder_Manager:GetCategoryData()
    return categoryData
end

-- TRIAL_FINDER_MANAGER = TrialFinder_Manager:New() -- TODO Uncomment to enable