local GAFE = GroupActivityFinderExtensions
local WM = WINDOW_MANAGER
local libScroll = LibScroll
-- local TrialQuest = GAFE.TrialChestTimer.TrialQuest

local ORDERED_TRIALS_ID = {
    AetherianArchive = 1,
    HelRaCitadel = 2,
    SanctumOphidia = 3,
    MawOfLorkhaj = 4,
    HallsOfFabrication = 5,
    AsylumSanctorium = 6,
    Cloudrest = 7,
    Sunspire = 8,
    KynesAegis = 9,
    Rockgrove = 10,
    DreadsailReef = 11,
}

local dataItems = {
    [ORDERED_TRIALS_ID.AetherianArchive] = {label=GAFE.Loc("TrialAetherianArchive"), activityId=GAFE_ACTIVITY_ID.NormalAetherianArchive},
    [ORDERED_TRIALS_ID.HelRaCitadel] = {label=GAFE.Loc("TrialHelRaCitadel"), activityId=GAFE_ACTIVITY_ID.NormalHelRaCitadel},
    [ORDERED_TRIALS_ID.SanctumOphidia] = {label=GAFE.Loc("TrialSanctumOphidia"), activityId=GAFE_ACTIVITY_ID.NormalSanctumOphidia},
    [ORDERED_TRIALS_ID.MawOfLorkhaj] = {label=GAFE.Loc("TrialMawOfLorkhaj"), activityId=GAFE_ACTIVITY_ID.NormalMawOfLorkhaj},
    [ORDERED_TRIALS_ID.HallsOfFabrication] = {label=GAFE.Loc("TrialHallsOfFabrication"), activityId=GAFE_ACTIVITY_ID.NormalHallsOfFabrication},
    [ORDERED_TRIALS_ID.AsylumSanctorium] = {label=GAFE.Loc("TrialAsylumSanctorium"), activityId=GAFE_ACTIVITY_ID.NormalAsylumSanctorium},
    [ORDERED_TRIALS_ID.Cloudrest] = {label=GAFE.Loc("TrialCloudrest"), activityId=GAFE_ACTIVITY_ID.NormalCloudrest},
    [ORDERED_TRIALS_ID.Sunspire] = {label=GAFE.Loc("TrialSunspire"), activityId=GAFE_ACTIVITY_ID.NormalSunspire},
    [ORDERED_TRIALS_ID.KynesAegis] = {label=GAFE.Loc("TrialKynesAegis"), activityId=GAFE_ACTIVITY_ID.NormalKynesAegis},
    [ORDERED_TRIALS_ID.Rockgrove] = {label=GAFE.Loc("TrialRockgrove"), activityId=GAFE_ACTIVITY_ID.NormalRockgrove},
    [ORDERED_TRIALS_ID.DreadsailReef] = {label=GAFE.Loc("TrialDreadsailReef"), activityId=GAFE_ACTIVITY_ID.NormalDreadsailReef}
}

GAFE_TrialsSchedule = ZO_Object:Subclass()

function GAFE_TrialsSchedule:New (...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function GAFE_TrialsSchedule:Initialize(control)
    self.control = control

    self.filter = self.control:GetNamedChild("Filter")

    self.listContainer = self.control:GetNamedChild("ContainerListContainer")

    self.characterId = GetCurrentCharacterId()

    self:InitializeControls()
end

function GAFE_TrialsSchedule:InitializeControls()
    self:InitializeFragment()
    self:InitializeFilter()
end

function GAFE_TrialsSchedule:InitializeFilter()
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

function GAFE_TrialsSchedule:InitializeFragment()
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

        label:SetText(data.label)
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
        name    = "GAFE_TrialsWindowScrollList",
        parent  = parent,
        rowHeight       = 30,
        rowTemplate     = "GAFE_TrialsScheduleRow",
        setupCallback   = SetupDataRow,
    }

    local scrollList = libScroll:CreateScrollList(scrollData)
    scrollList:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
    scrollList:SetAnchor(BOTTOMRIGHT, parent, BOTTOMRIGHT, 0, 0)

    scrollList:Update(dataItems)

    self.scrollList = scrollList

    ZO_PreHookHandler(ZO_SearchingForGroup, 'OnEffectivelyShown', function() self.scrollList:Update(dataItems) end)
end

function GAFE_TrialsSchedule:OnFilterChanged(comboBox, entryText, entry)
    self.characterId = entry.data
    self.scrollList:Update(dataItems)
end

function GAFE_TrialsSchedule:UpdateChestLabel(label, questId)
    local chestText = ""
    local timeUntilNextChest = GAFE_TRIALS_CHESTS.GetTimeUntilNextChest(self.characterId, questId)
    if timeUntilNextChest > 0 then
        chestText = GAFE.ParseTimeStamp(timeUntilNextChest)
    end
    label:SetText(chestText)
end

function GAFE_TrialsSchedule_Init(control)
    GAFE.ActivitySchedule = GAFE_TrialsSchedule:New(control)
end
