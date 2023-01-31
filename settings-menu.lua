local GAFE = GroupActivityFinderExtensions
local LAM = LibAddonMenu2

-- local ResetChest = GAFE.TrialChestTimer.ResetChest
local characterId = GetCurrentCharacterId()

GAFE.SettingsMenu = {}

local collapseModeToString = {
    [GAFE_COLLAPSE_MODE.Group] = GAFE.Loc("CollapseMode_Group"),
    [GAFE_COLLAPSE_MODE.Normal] = GAFE.Loc("CollapseMode_Normal"),
    [GAFE_COLLAPSE_MODE.Veteran] = GAFE.Loc("CollapseMode_Veteran")
}
local stringToCollapseMode = {
    [GAFE.Loc("CollapseMode_Group")] = GAFE_COLLAPSE_MODE.Group,
    [GAFE.Loc("CollapseMode_Normal")] = GAFE_COLLAPSE_MODE.Normal,
    [GAFE.Loc("CollapseMode_Veteran")] = GAFE_COLLAPSE_MODE.Veteran,
}

function GAFE.SettingsMenu.Init()
    local saveData = GAFE.SavedVars -- This should be a reference to your actual saved variables table
    local panelName = GAFE.name .. "_SettingsPanel" -- The name will be used to create a global variable, pick something unique or you may overwrite an existing variable!

    local panelData = {
        type = "panel",
        name = "Group & Activity Finder Extensions",
        author = "Panicida",
        registerForRefresh = true
    }
    local optionsData = {
        {
            type = "description",
            text = GAFE.Loc("Settings_Description")
        },
        {
            type = "slider",
            name = GAFE.Loc("Settings_TextureSize"),
            getFunc = function() return saveData.textureSize end,
            setFunc = function(value) saveData.textureSize = value end,
            max = 30,
            min = 20,
            step = 1,
        },
        {
            type = "dropdown",
            name = GAFE.Loc("Settings_Difficulty"),
            choices = { collapseModeToString[GAFE_COLLAPSE_MODE.Group], collapseModeToString[GAFE_COLLAPSE_MODE.Normal],
                collapseModeToString[GAFE_COLLAPSE_MODE.Veteran] },
            getFunc = function() return collapseModeToString[saveData.collapse] end,
            setFunc = function(value) saveData.collapse = stringToCollapseMode[value] end
        },
        {
            type = "checkbox",
            name = GAFE.Loc("Settings_AutoConfirm"),
            getFunc = function() return saveData.autoConfirm.enabled end,
            setFunc = function(value) GAFE_QUEUE_EXTENSIONS.AutoConfirm(value) end
        },
        {
            type = "slider",
            name = GAFE.Loc("Settings_AutoConfirmDelay"),
            getFunc = function() return saveData.autoConfirm.delay / 1000 end,
            setFunc = function(value) saveData.autoConfirm.delay = value * 1000 end,
            max = 40,
            min = 1,
            step = 1,
        },
        {
            type = "checkbox",
            name = GAFE.Loc("Settings_LoopQueueCompletedNotification"),
            getFunc = function() return saveData.autoConfirm.loopSound end,
            setFunc = function(value) saveData.autoConfirm.loopSound = value end
        },
        {
            type = "checkbox",
            name = GAFE.Loc("Settings_AutoMarkPledges"),
            getFunc = function() return saveData.dungeons.autoMarkPledges end,
            setFunc = function(value) saveData.dungeons.autoMarkPledges = value end
        },
        -- {
        --     type = "checkbox",
        --     name = GAFE.Loc("Settings_AutoInvite"),
        --     getFunc = function() return saveData.autoInvite.enabled end,
        --     setFunc = function(value) GAFE.QueueManager.Enable(value) end
        -- },
        {
            type = "checkbox",
            name = GAFE.Loc("Settings_HandleQuest"),
            getFunc = function() return saveData.dungeons.handlePledgeQuest end,
            setFunc = function(value) GAFE_QUEST_AUTOMATION.AutomaticallyHandleQuests(value) end
        },
        {
            type = "submenu",
            name = GAFE.Loc("Settings_CompatibilityTitle"),
            controls = {
                {
                    type = "checkbox",
                    name = GAFE.Loc("Settings_PerfectPixelAddon"),
                    getFunc = function() return saveData.compatibility.perfectPixel end,
                    setFunc = function(value) saveData.compatibility.perfectPixel = value end,
                    requiresReload = true
                },
            }
        },
        {
            type = "divider"
        },
        {
            type = "submenu",
            name = GAFE.Loc("Settings_ResetPremiumRewards"),
            controls = {
                {
                    type = "button",
                    name = GetString(SI_DUNGEON_FINDER_GENERAL_ACTIVITY_DESCRIPTOR),
                    func = function() GAFE.SavedVars.dungeons.randomRewards[characterId] = GetTimeStamp() end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetReward"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GetString(SI_BATTLEGROUND_FINDER_GENERAL_ACTIVITY_DESCRIPTOR),
                    func = function() GAFE.SavedVars.battlegrounds.randomRewards[characterId] = GetTimeStamp() end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetReward"),
                    isDangerous = true
                }
            }
        },
        {
            type = "divider"
        },
        {
            type = "submenu",
            name = GAFE.Loc("Settings_TrialsChest"),
            controls = {
                {
                    type = "button",
                    name = GAFE.Loc("TrialAetherianArchive"),
                    func = function() return GAFE_TRIALS_CHESTS.ResetChest(GAFE_TRIALS_ACTIVITY_DATA[
                            GAFE_ACTIVITY_ID.NormalAetherianArchive].q)
                    end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialHelRaCitadel"),
                    func = function() return GAFE_TRIALS_CHESTS.ResetChest(GAFE_TRIALS_ACTIVITY_DATA[
                            GAFE_ACTIVITY_ID.NormalHelRaCitadel].q)
                    end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialSanctumOphidia"),
                    func = function() return GAFE_TRIALS_CHESTS.ResetChest(GAFE_TRIALS_ACTIVITY_DATA[
                            GAFE_ACTIVITY_ID.NormalSanctumOphidia].q)
                    end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialMawOfLorkhaj"),
                    func = function() return GAFE_TRIALS_CHESTS.ResetChest(GAFE_TRIALS_ACTIVITY_DATA[
                            GAFE_ACTIVITY_ID.NormalMawOfLorkhaj].q)
                    end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialHallsOfFabrication"),
                    func = function() return GAFE_TRIALS_CHESTS.ResetChest(GAFE_TRIALS_ACTIVITY_DATA[
                            GAFE_ACTIVITY_ID.NormalHallsOfFabrication].q)
                    end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialAsylumSanctorium"),
                    func = function() return GAFE_TRIALS_CHESTS.ResetChest(GAFE_TRIALS_ACTIVITY_DATA[
                            GAFE_ACTIVITY_ID.NormalAsylumSanctorium].q)
                    end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialCloudrest"),
                    func = function() return GAFE_TRIALS_CHESTS.ResetChest(GAFE_TRIALS_ACTIVITY_DATA[
                            GAFE_ACTIVITY_ID.NormalCloudrest].q)
                    end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialSunspire"),
                    func = function() return GAFE_TRIALS_CHESTS.ResetChest(GAFE_TRIALS_ACTIVITY_DATA[
                            GAFE_ACTIVITY_ID.NormalSunspire].q)
                    end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialKynesAegis"),
                    func = function() return GAFE_TRIALS_CHESTS.ResetChest(GAFE_TRIALS_ACTIVITY_DATA[
                            GAFE_ACTIVITY_ID.NormalKynesAegis].q)
                    end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
                {
                    type = "button",
                    name = GAFE.Loc("TrialDreadsailReef"),
                    func = function() return GAFE_TRIALS_CHESTS.ResetChest(GAFE_TRIALS_ACTIVITY_DATA[
                            GAFE_ACTIVITY_ID.NormalDreadsailReef].q)
                    end,
                    width = "half",
                    warning = GAFE.Loc("Settings_ResetChestWarning"),
                    isDangerous = true
                },
            },
        },
        {
            type = "submenu",
            name = "Developer",
            controls = {
                {
                    type = "checkbox",
                    name = 'Developer mode',
                    getFunc = function() return saveData.developerMode end,
                    setFunc = function(value) saveData.developerMode = value end,
                    warning = "Intended only for developers",
                    isDangerous = true
                }
            }
        },
    }

    LAM:RegisterAddonPanel(panelName, panelData)
    LAM:RegisterOptionControls(panelName, optionsData)
end
