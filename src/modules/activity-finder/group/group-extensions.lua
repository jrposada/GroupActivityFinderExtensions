local GAFE = GroupActivityFinderExtensions

GAFE_GROUP_EXTENSIONS = {}

function GAFE_GROUP_EXTENSIONS.Init()
    local baseSetupGroupEntry = GROUP_LIST.SetupGroupEntry

    local function SetupGroupEntry(self, control, data)
        baseSetupGroupEntry(self, control, data)
        local isPreferUserId = ZO_ShouldPreferUserId()

        if isPreferUserId then
            control.characterNameLabel:SetText(
                zo_strformat(
                    SI_GROUP_LIST_PANEL_CHARACTER_NAME,
                    data.index,
                    data.displayName
                )
            )
        end
    end

    function UpdateHook(self, control)
        local row = control:GetParent()
        local data = ZO_ScrollList_GetData(row)
        local isPreferUserId = ZO_ShouldPreferUserId()

        if isPreferUserId then
            InformationTooltip:ClearLines()
            SetTooltipText(
                InformationTooltip,
                data.rawCharacterName
            )
        end
    end

    GROUP_LIST.SetupGroupEntry = SetupGroupEntry
    ZO_PostHook(ZO_SocialListKeyboard, 'CharacterName_OnMouseEnter', UpdateHook)
end
