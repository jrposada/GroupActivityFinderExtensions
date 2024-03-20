local GAFE = GroupActivityFinderExtensions
local libScroll = LibScroll
local LQD = LibQuestData
local LQD_Internal = _G["LibQuestData_Internal"]

local dataItems = {}

GAFE_QuestsSchedule = ZO_Object:Subclass()

function GAFE_QuestsSchedule:New(...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function GAFE_QuestsSchedule:Initialize(control)
    self.control = control

    self.filter = self.control:GetNamedChild("Filter")

    self.listContainer = self.control:GetNamedChild("ContainerListContainer")

    self.characterId = GetCurrentCharacterId()

    self:InitializeData()
    self:InitializeControls()
end

function GAFE_QuestsSchedule:InitializeData()
    for zoneName, zone in pairs(LQD_Internal.quest_locations) do
        local quests = {}
        for _, questPinData in ipairs(zone) do
            local questId = questPinData[LQD.quest_map_pin_index.quest_id]
            local npcName = LQD:get_quest_giver(questPinData[LQD.quest_map_pin_index.quest_giver], GAFE.lang)

            table.insert(quests, { questId = questId, npcName = npcName })
        end
        table.insert(dataItems, { zoneName = zoneName, quests = quests })
    end
    table.sort(dataItems, function(a, b)
        return a.zoneName < b.zoneName
    end)
end

function GAFE_QuestsSchedule:InitializeControls()
    self:InitializeFragment()
    self:InitializeFilter()
end

function GAFE_QuestsSchedule:InitializeFilter()
    local function OnFilterChanged(...)
        self:OnFilterChanged(...)
    end

    local filterComboBox = ZO_ComboBox_ObjectFromContainer(self.filter)
    filterComboBox:SetSortsItems(false)
    filterComboBox:SetFont("ZoFontWinT1")
    filterComboBox:SetSpacing(4)
    self.filterComboBox = filterComboBox

    local currentCharacterEntry
    local numCharacters = GetNumCharacters()
    for i = 1, numCharacters do
        local characterName, _, _, _, _, _, id, _ = GetCharacterInfo(i)

        local entry = ZO_ComboBox:CreateItemEntry(zo_strformat("<<1>>", characterName), OnFilterChanged)
        entry.data = id
        if id == self.characterId then
            currentCharacterEntry = entry
        end
        self.filterComboBox:AddItem(entry, ZO_COMBOBOX_SUPPRESS_UPDATE)
    end

    self.filterComboBox:SelectItem(currentCharacterEntry)
end

function GAFE_QuestsSchedule:InitializeFragment()
    local function SetupDataRow(rowControl, data, scrollList)
        local trialsData = GAFE_TRIALS_ACTIVITY_DATA

        -- Do whatever you want/need to setup the control
        local control = rowControl
        local label = control:GetNamedChild("Label")
        local state = control:GetNamedChild("State")

        local height = 30
        local labelWidth = 350
        local pledgeWidth = 165

        label:SetDimensions(labelWidth, height)
        label:SetAnchor(TOPLEFT, control, TOPLEFT, 0, 0)
        state:SetDimensions(pledgeWidth, height)
        state:SetAnchor(TOPRIGHT, control, TOPRIGHT, 0, 0)

        label:SetText(data.zoneName)
        local activityData = trialsData[data.activityId]
        if activityData and GAFE_TRIALS_CHESTS ~= nil then
            local chestAvailable = GAFE_TRIALS_CHESTS.GetTimeUntilNextChest(self.characterId, activityData.q) <= 0
            if chestAvailable == true then
                state:SetHandler("OnUpdate", nil)
                state:SetText("|cFFD700" .. GAFE.Loc("Available") .. "|r")
            else
                self:UpdateChestLabel(state, activityData.q)
                state:SetHandler("OnUpdate", function() self:UpdateChestLabel(state, activityData.q) end)
            end
        end
    end

    local parent = self.listContainer

    -- Create the scroll list
    local scrollData = {
        name          = "GAFE_QuestsWindowScrollList",
        parent        = parent,
        rowHeight     = 30,
        rowTemplate   = "GAFE_QuestsScheduleRow",
        setupCallback = SetupDataRow,
    }

    local scrollList = libScroll:CreateScrollList(scrollData)
    scrollList:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
    scrollList:SetAnchor(BOTTOMRIGHT, parent, BOTTOMRIGHT, 0, 0)

    scrollList:Update(dataItems)

    self.scrollList = scrollList

    ZO_PreHookHandler(ZO_SearchingForGroup, 'OnEffectivelyShown', function() self.scrollList:Update(dataItems) end)
end

function GAFE_QuestsSchedule:OnFilterChanged(comboBox, entryText, entry)
    self.characterId = entry.data
    self.scrollList:Update(dataItems)
end

function GAFE_QuestsSchedule:UpdateChestLabel(label, questId)
    local chestText = ""
    local timeUntilNextChest = GAFE_TRIALS_CHESTS.GetTimeUntilNextChest(self.characterId, questId)
    if timeUntilNextChest > 0 then
        chestText = GAFE.ParseTimeStamp(timeUntilNextChest)
    end
    label:SetText(chestText)
end

function GAFE_QuestsSchedule_Init(control)
    GAFE.ActivitySchedule = GAFE_QuestsSchedule:New(control)
end
