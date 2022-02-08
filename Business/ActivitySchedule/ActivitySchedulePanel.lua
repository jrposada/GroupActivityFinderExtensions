local GAFE = GroupActivityFinderExtensions

ActivitySchedule = ZO_Object:Subclass()

function ActivitySchedule:New (...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function ActivitySchedule:Initialize(control)
    self.control = control

    self.filterControl = self.control:GetNamedChild("Filter")

    self:InitializeControls()
    -- self:RegisterEvents()
end

function ActivitySchedule:InitializeControls()
    self:InitializeFragment()
    self:InitializeFilters()
end

function ActivitySchedule:InitializeFilters()
    local filterComboBox = ZO_ComboBox_ObjectFromContainer(self.filterControl)
    filterComboBox:SetSortsItems(false)
    filterComboBox:SetFont("ZoFontWinT1")
    filterComboBox:SetSpacing(4)
    self.filterComboBox = filterComboBox
    self:BuildComboOptions()
end

function ActivitySchedule:InitializeFragment()
    --Meant to be overriden
end

function ActivitySchedule:BuildComboOptions()
    local entries = {{activityName = GAFE.Loc("ActivityTrails"), activityType = 'trials'}, {activityName = GAFE.Loc("ActivityPledges"), activityType = 'pledge'},}

    local function OnFilterChanged(...)
        self:OnFilterChanged(...)
    end

    for _, info in ipairs(entries) do
        local entry = ZO_ComboBox:CreateItemEntry(info.activityName, OnFilterChanged)
        entry.data =
        {
            singular = false,
            activityType = info.activityType,
        }
        self.filterComboBox:AddItem(entry, ZO_COMBOBOX_SUPPRESS_UPDATE)
    end

    self.filterComboBox:SelectFirstItem()
end

function ActivitySchedule:OnFilterChanged(comboBox, entryText, entry)

end

function GAFE_ActivitySchedulePanel_OnInitialized(control)
    GAFE.ActivitySchedule = ActivitySchedule:New(control)
end