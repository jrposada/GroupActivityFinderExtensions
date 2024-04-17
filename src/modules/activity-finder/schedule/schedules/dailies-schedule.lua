local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER
local libScroll = LibScroll

GAFE_DailiesSchedule = ZO_Object:Subclass()

function GAFE_DailiesSchedule:New(...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function GAFE_DailiesSchedule:Initialize(control)
    self.control = control
    self.rowsControlData = {}

    self.header = self.control:GetNamedChild("Header")
    self.listContainer = self.control:GetNamedChild("ListContainer")

    self:InitializeControls()
    self:InitializeEvents()
end

function GAFE_DailiesSchedule:InitializeControls()
    self:InitializeFragment()
end

function GAFE_DailiesSchedule:InitializeFragment()
    local function SetupHeaderRow(rowControl, data)
        -- Do whatever you want/need to setup the control
        local control = rowControl
        local label = control:GetNamedChild("Label")
        local dungeon = control:GetNamedChild("Dungeon")
        local battleground = control:GetNamedChild("Battleground")

        label:SetText(data.name)
        dungeon:SetText(data.dungeon)
        battleground:SetText(data.battleground)

        label:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
        dungeon:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
        battleground:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))

        local height = 30
        local labelWidth = 400
        local pledgeWidth = 100

        label:SetDimensions(labelWidth, height)
        label:SetAnchor(TOPLEFT, control, TOPLEFT, 0, 0)
        dungeon:SetDimensions(pledgeWidth, height)
        dungeon:SetAnchor(TOPLEFT, control, TOPLEFT, labelWidth, 0)
        battleground:SetDimensions(pledgeWidth, height)
        battleground:SetAnchor(TOPLEFT, control, TOPLEFT, labelWidth + pledgeWidth, 0)
    end

    local function SetupDataRow(rowControl, data, scrollList)
        -- Do whatever you want/need to setup the control
        local control = rowControl
        local label = control:GetNamedChild("Label")
        local dungeon = control:GetNamedChild("Dungeon")
        local battleground = control:GetNamedChild("Battleground")

        label:SetText(data.name)

        local height = 30
        local labelWidth = 400
        local pledgeWidth = 100

        label:SetDimensions(labelWidth, height)
        label:SetAnchor(TOPLEFT, control, TOPLEFT, 0, 0)
        dungeon:SetDimensions(pledgeWidth, height)
        dungeon:SetAnchor(TOPLEFT, control, TOPLEFT, labelWidth, 0)
        battleground:SetDimensions(pledgeWidth, height)
        battleground:SetAnchor(TOPLEFT, control, TOPLEFT, labelWidth + pledgeWidth, 0)

        self.rowsControlData[data.name] = { control = rowControl, data = data }
    end

    -- Setup header
    SetupHeaderRow(
        self.header,
        {
            name = GAFE.Loc("Character"),
            dungeon = GetString(SI_DUNGEON_FINDER_GENERAL_ACTIVITY_DESCRIPTOR),
            battleground = GetString(SI_BATTLEGROUND_FINDER_GENERAL_ACTIVITY_DESCRIPTOR)
        }
    )

    -- Create the scroll list
    local parent = self.listContainer
    local scrollData = {
        name          = "GAFE_DailiesWindowScrollList",
        parent        = parent,
        rowHeight     = 30,
        rowTemplate   = "GAFE_DailiesScheduleRow",
        setupCallback = SetupDataRow,
    }

    local scrollList = libScroll:CreateScrollList(scrollData)
    scrollList:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
    scrollList:SetAnchor(BOTTOMRIGHT, parent, BOTTOMRIGHT, 0, 0)

    -- Add data to scroll list.
    local dataItems = {
    }
    local numCharacters = GetNumCharacters()
    for i = 1, numCharacters do
        local characterName, _, _, _, _, _, characterId, _ = GetCharacterInfo(i)

        local data = {
            name = zo_strformat("<<1>>", characterName),
            characterId = characterId,
        }
        dataItems[i] = data
    end
    scrollList:Update(dataItems)

    self.scrollList = scrollList
end

function GAFE_DailiesSchedule:UpdateDataRows()
    for _, rowControlData in pairs(self.rowsControlData) do
        local control = rowControlData.control
        local data = rowControlData.data

        local dungeon = control:GetNamedChild("Dungeon")
        local battleground = control:GetNamedChild("Battleground")

        local nextDailyBattleground = GAFE_ActivityFinderExtender.GetTimeUntilNextReward(data.characterId,
            GAFE.SavedVars.battlegrounds)
        local nextDailyDungeon = GAFE_ActivityFinderExtender.GetTimeUntilNextReward(data.characterId,
            GAFE.SavedVars.dungeons)

        dungeon:SetText(nextDailyDungeon > 0 and
        ZO_FormatTime(nextDailyDungeon, TIME_FORMAT_STYLE_COLONS, TIME_FORMAT_PRECISION_SECONDS) or "|cFFD700Available|r")
        battleground:SetText(nextDailyBattleground > 0 and
        ZO_FormatTime(nextDailyBattleground, TIME_FORMAT_STYLE_COLONS, TIME_FORMAT_PRECISION_SECONDS) or
        "|cFFD700Available|r")
    end
end

function GAFE_DailiesSchedule:InitializeEvents()
    ZO_PreHookHandler(GAFE_DailiesWindowScrollList, 'OnEffectivelyShown', function()
        self:UpdateDataRows()
        EM:RegisterForUpdate("GAFE_DailiesSchedule_UpdateScrollList", 1000, function() self:UpdateDataRows() end)
    end)
    ZO_PreHookHandler(GAFE_DailiesWindowScrollList, 'OnEffectivelyHidden',
        function() EM:UnregisterForUpdate("GAFE_DailiesSchedule_UpdateScrollList") end)
end

function GAFE_DailiesSchedule_Init(control)
    GAFE.ActivitySchedule = GAFE_DailiesSchedule:New(control)
end
