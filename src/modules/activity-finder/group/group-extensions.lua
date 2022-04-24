local GAFE = GroupActivityFinderExtensions

GAFE_GROUP_EXTENSIONS = {}

function GAFE_GROUP_EXTENSIONS.Init()
    local baseSetupGroupEntry = GROUP_LIST.SetupGroupEntry

    local function SetupGroupEntry(self, control, data)
        baseSetupGroupEntry(self, control, data)

        control.characterNameLabel:SetText(
            zo_strformat(SI_GROUP_LIST_PANEL_CHARACTER_NAME,
            data.index,
            data.displayName))
    end

    GROUP_LIST.SetupGroupEntry = SetupGroupEntry
end
