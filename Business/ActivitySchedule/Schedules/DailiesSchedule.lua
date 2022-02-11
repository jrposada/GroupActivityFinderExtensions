local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER
local libScroll = LibScroll

GAFE_DailiesSchedule = ZO_Object:Subclass()

function GAFE_DailiesSchedule:New (...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function GAFE_DailiesSchedule:Initialize(control)
    self.control = control

    self.header = self.control:GetNamedChild("Header")
    self.listContainer = self.control:GetNamedChild("ListContainer")

    self:InitializeControls()
end

function GAFE_DailiesSchedule:InitializeControls()
    self:InitializeFragment()
end

function GAFE_DailiesSchedule:InitializeFragment()
    local function SetupDataRow(rowControl, data, scrollList)
        -- Do whatever you want/need to setup the control
        local control = rowControl
        local label = control:GetNamedChild("Label")
        local dungeon = control:GetNamedChild("Dungeon")
        local battleground = control:GetNamedChild("Battleground")

        label:SetText(data.name)
        dungeon:SetText(data.dungeon)
        battleground:SetText(data.battleground)

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

    -- Setup header
    SetupDataRow(
        self.header,
        {
            name=GAFE.Loc("Character"),
            dungeon=GetString(SI_DUNGEON_FINDER_GENERAL_ACTIVITY_DESCRIPTOR),
            battleground=GetString(SI_BATTLEGROUND_FINDER_GENERAL_ACTIVITY_DESCRIPTOR)
        }
    )

    -- Create the scroll list
    local parent = self.listContainer
    local scrollData = {
        name    = "GAFE_DailiesWindowScrollList",
        parent  = parent,
        rowHeight       = 30,
        rowTemplate     = "GAFE_DailiesScheduleRow",
        setupCallback   = SetupDataRow,
    }

    local scrollList = libScroll:CreateScrollList(scrollData)
    scrollList:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
    scrollList:SetAnchor(BOTTOMRIGHT, parent, BOTTOMRIGHT, 0, 0)

    -- Add data to scroll list.
    local dataItems = {
    }
    local numCharacters = GetNumCharacters()
    local battlegroundsRewardsVars = GAFE.SavedVars.battlegrounds
    local dungeonsRewardsVars = GAFE.SavedVars.dungeons
    for i = 1, numCharacters do
        local characterName, _, _, _, _, _, characterId, _ = GetCharacterInfo(i)
        local nextDailyBattleground = RandomActivityExtender_GetTimeUntilNextReward(characterId, battlegroundsRewardsVars)
        local nextDailyDungeon = RandomActivityExtender_GetTimeUntilNextReward(characterId, dungeonsRewardsVars)

        local data = {
            name=zo_strformat("<<1>>", characterName),
            battleground=nextDailyBattleground > 0 and nextDailyBattleground or "|cFFD700Available|r",
            dungeon=nextDailyDungeon > 0 and nextDailyDungeon or '|cFFD700Available|r',
        }
        dataItems[i] = data
    end
    scrollList:Update(dataItems)

    self.scrollList = scrollList
end

function GAFE_DailiesSchedule_Init(control)
    GAFE.ActivitySchedule = GAFE_DailiesSchedule:New(control)
end
