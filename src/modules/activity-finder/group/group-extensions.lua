local GAFE = GroupActivityFinderExtensions

GAFE_GROUP_EXTENSIONS = {}

local function IsPreferUserId()
    return GetSetting(SETTING_TYPE_UI, UI_SETTING_PRIMARY_PLAYER_NAME_KEYBOARD) == PRIMARY_PLAYER_NAME_SETTING_PREFER_USERID
end

function GAFE_GROUP_EXTENSIONS.Init()
    local baseSetupGroupEntry = GROUP_LIST.SetupGroupEntry

    local function SetupGroupEntry(self, control, data)
        baseSetupGroupEntry(self, control, data)

        local isPreferUserId = IsPreferUserId()
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

    function UpdateHook(control)
        local row = control:GetParent()
        local data = ZO_ScrollList_GetData(row)

        local isPreferUserId = IsPreferUserId()
        if isPreferUserId then
            SetTooltipText(
                InformationTooltip,
                zo_strformat(
                    SI_GROUP_LIST_PANEL_CHARACTER_NAME,
                    data.index,
                    data.rawCharacterName
                )
            )
        end
    end

    GROUP_LIST.SetupGroupEntry = SetupGroupEntry
    ZO_PreHook(ZO_GroupListRowCharacterName_OnMouseEnter, UpdateHook)
end

-- * SetSetting(*[SettingSystemType|#SettingSystemType]* _system_, *integer* _settingId_, *string* _value_, *[SetOptions|#SetOptions]* _setOptions_)

-- * GetSetting(*[SettingSystemType|#SettingSystemType]* _system_, *integer* _settingId_)
-- ** _Returns:_ *string* _value_

-- * GetSetting_Bool(*[SettingSystemType|#SettingSystemType]* _system_, *integer* _settingId_)
-- ** _Returns:_ *bool* _value_

-- h5. SettingSystemType
-- * SETTING_TYPE_ACCESSIBILITY
-- * SETTING_TYPE_ACCOUNT
-- * SETTING_TYPE_ACTION_BARS
-- * SETTING_TYPE_ACTIVE_COMBAT_TIP
-- * SETTING_TYPE_AUDIO
-- * SETTING_TYPE_BUFFS
-- * SETTING_TYPE_CAMERA
-- * SETTING_TYPE_CHAT_BUBBLE
-- * SETTING_TYPE_CHAT_GLOBALS
-- * SETTING_TYPE_CHAT_TABS
-- * SETTING_TYPE_COMBAT
-- * SETTING_TYPE_DEVELOPER_DEBUG
-- * SETTING_TYPE_GAMEPAD
-- * SETTING_TYPE_GRAPHICS
-- * SETTING_TYPE_IN_WORLD
-- * SETTING_TYPE_LANGUAGE
-- * SETTING_TYPE_LOOT
-- * SETTING_TYPE_NAMEPLATES
-- * SETTING_TYPE_SUBTITLES
-- * SETTING_TYPE_TUTORIAL
-- * SETTING_TYPE_UI
-- * SETTING_TYPE_VOICE

-- SetSetting(data.system, data.settingId, tostring(value))
