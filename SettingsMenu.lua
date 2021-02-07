local GAFE = GroupActivityFinderExtensions
local LAM = LibAddonMenu2

GAFE.SettingsMenu = {}


function GAFE.SettingsMenu.Init()
    local saveData = GAFE.SavedVars -- This should be a reference to your actual saved variables table
    local panelName = GAFE.name.."_SettingsPanel" -- The name will be used to create a global variable, pick something unique or you may overwrite an existing variable!

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
            type = "checkbox",
            name = GAFE.Loc("Settings_AutoConfirm"),
            getFunc = function() return saveData.autoConfirm.enabled end,
            setFunc = function(value) GAFE.AutoConfirm.Enable(value) end
        }
    }

    LAM:RegisterAddonPanel(panelName, panelData)
    LAM:RegisterOptionControls(panelName, optionsData)
end