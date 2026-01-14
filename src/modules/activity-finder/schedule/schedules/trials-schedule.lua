local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER
local libScroll = LibScroll

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
  [ORDERED_TRIALS_ID.AetherianArchive] = { label = GAFE.Loc("TrialAetherianArchive"), activityId = GAFE_ACTIVITY_ID.NormalAetherianArchive },
  [ORDERED_TRIALS_ID.HelRaCitadel] = { label = GAFE.Loc("TrialHelRaCitadel"), activityId = GAFE_ACTIVITY_ID.NormalHelRaCitadel },
  [ORDERED_TRIALS_ID.SanctumOphidia] = { label = GAFE.Loc("TrialSanctumOphidia"), activityId = GAFE_ACTIVITY_ID.NormalSanctumOphidia },
  [ORDERED_TRIALS_ID.MawOfLorkhaj] = { label = GAFE.Loc("TrialMawOfLorkhaj"), activityId = GAFE_ACTIVITY_ID.NormalMawOfLorkhaj },
  [ORDERED_TRIALS_ID.HallsOfFabrication] = { label = GAFE.Loc("TrialHallsOfFabrication"), activityId = GAFE_ACTIVITY_ID.NormalHallsOfFabrication },
  [ORDERED_TRIALS_ID.AsylumSanctorium] = { label = GAFE.Loc("TrialAsylumSanctorium"), activityId = GAFE_ACTIVITY_ID.NormalAsylumSanctorium },
  [ORDERED_TRIALS_ID.Cloudrest] = { label = GAFE.Loc("TrialCloudrest"), activityId = GAFE_ACTIVITY_ID.NormalCloudrest },
  [ORDERED_TRIALS_ID.Sunspire] = { label = GAFE.Loc("TrialSunspire"), activityId = GAFE_ACTIVITY_ID.NormalSunspire },
  [ORDERED_TRIALS_ID.KynesAegis] = { label = GAFE.Loc("TrialKynesAegis"), activityId = GAFE_ACTIVITY_ID.NormalKynesAegis },
  [ORDERED_TRIALS_ID.Rockgrove] = { label = GAFE.Loc("TrialRockgrove"), activityId = GAFE_ACTIVITY_ID.NormalRockgrove },
  [ORDERED_TRIALS_ID.DreadsailReef] = { label = GAFE.Loc("TrialDreadsailReef"), activityId = GAFE_ACTIVITY_ID.NormalDreadsailReef }
}

GAFE_TrialsSchedule = ZO_Object:Subclass()

function GAFE_TrialsSchedule:New(...)
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
  self:InitializeCountdownLabel()
  self:InitializeEvents()
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

    local entry = ZO_ComboBox:CreateItemEntry(
      zo_strformat("<<1>>", characterName),
      OnFilterChanged
    )
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
      local chestAvailable = GAFE_TRIALS_CHESTS.GetTimeUntilNextChest(
        self.characterId,
        activityData.q
      ) <= 0
      if chestAvailable then
        state:SetText("|cFFD700" .. GAFE.Loc("Available") .. "|r")
      else
        state:SetText("|c32CD32" .. GAFE.Loc("Done") .. "|r")
      end
    end
  end

  local parent = self.listContainer

  -- Create the scroll list
  local scrollData = {
    name          = "GAFE_TrialsWindowScrollList",
    parent        = parent,
    rowHeight     = 30,
    rowTemplate   = "GAFE_TrialsScheduleRow",
    setupCallback = SetupDataRow,
  }

  local scrollList = libScroll:CreateScrollList(scrollData)
  scrollList:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
  scrollList:SetAnchor(BOTTOMRIGHT, parent, BOTTOMRIGHT, 0, 0)

  scrollList:Update(dataItems)

  self.scrollList = scrollList

  ZO_PreHookHandler(ZO_SearchingForGroup, 'OnEffectivelyShown',
    function() self.scrollList:Update(dataItems) end)
end

function GAFE_TrialsSchedule:OnFilterChanged(comboBox, entryText, entry)
  self.characterId = entry.data
  self.scrollList:Update(dataItems)
end

function GAFE_TrialsSchedule:InitializeCountdownLabel()
  self.countdownLabel = WINDOW_MANAGER:CreateControl(
    self.control:GetName() .. "Countdown", self.control, CT_LABEL)
  self.countdownLabel:SetFont("ZoFontWinH4")
  self.countdownLabel:SetColor(GetInterfaceColor(
    INTERFACE_COLOR_TYPE_TEXT_COLORS,
    INTERFACE_TEXT_COLOR_NORMAL))
  self.countdownLabel:ClearAnchors()
  self.countdownLabel:SetAnchor(BOTTOM, self.control, BOTTOM, 0, -10)
  self.countdownLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
end

function GAFE_TrialsSchedule:UpdateCountdownLabel()
  local timeRemaining = GAFE.RewardTracker.GetTimeUntilWeeklyReset()
  if timeRemaining > 0 then
    local formattedTime = ZO_FormatTime(
      timeRemaining,
      TIME_FORMAT_STYLE_SHOW_LARGEST_UNIT_DESCRIPTIVE,
      TIME_FORMAT_PRECISION_SECONDS
    )
    self.countdownLabel:SetText(GAFE.Loc("WeeklyReset") .. ": " .. formattedTime)
  end
end

function GAFE_TrialsSchedule:InitializeEvents()
  ZO_PreHookHandler(self.control, 'OnEffectivelyShown',
    function()
      self:UpdateCountdownLabel()
      EM:RegisterForUpdate("GAFE_TrialsSchedule_UpdateCountdown", 1000,
        function() self:UpdateCountdownLabel() end)
    end)
  ZO_PreHookHandler(self.control, 'OnEffectivelyHidden',
    function() EM:UnregisterForUpdate("GAFE_TrialsSchedule_UpdateCountdown") end)
end

function GAFE_TrialsSchedule_Init(control)
  GAFE.ActivitySchedule = GAFE_TrialsSchedule:New(control)
end
