local GAFE = GroupActivityFinderExtensions
local WM = WINDOW_MANAGER

ActivitySchedule = ZO_Object:Subclass()

function ActivitySchedule:New (...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function ActivitySchedule:Initialize(control)
    self.control = control

    self.trialsWindow = self.control:GetNamedChild("TrialsWindow")
    self.pledgesWindow = self.control:GetNamedChild("PledgesWindow")
    self.randomActivitiesWindow = self.control:GetNamedChild("RandomActivitiesWindow")
    self.menuBar = self.control:GetNamedChild("MenuBar")
    self.menuBarLabel = self.menuBar:GetNamedChild('Label')

    self:InitializeControls()
    -- self:RegisterEvents()
end

function ActivitySchedule:InitializeControls()
    self:InitializeFragment()
    self:InitializeActivitiesList()
end

function ActivitySchedule:InitializeFragment()
    self:InitializeMenuBar()

    -- local trialsScheduleControl = WM:CreateControlFromVirtual("GAFE_Schedule_TrialsSchedule", self.infoContainer, "GAFE_TrialsSchedule")
    -- self.trialsSchedule = GAFE_TrialsSchedule:New(trialsScheduleControl)
end

function ActivitySchedule:InitializeMenuBar()
    local function MenuSelector(data)
        local name = self.menuBar:GetName()

        self.trialsWindow:SetHidden(data.descriptor ~= name.."ButtonTrials")
        self.pledgesWindow:SetHidden(data.descriptor ~= name.."ButtonPledges")
        self.randomActivitiesWindow:SetHidden(data.descriptor ~= name.."ButtonRandomActivities")
        self.menuBarLabel:SetText( data.label )
        -- LGM.SV.panelSelection = data.descriptor
     end

     local name = self.menuBar:GetName()
     ZO_MenuBar_AddButton(self.menuBar, {
                 descriptor = name.."ButtonTrials",
                 normal = "esoui/art/campaign/overview_indexicon_emperor_up.dds",
                 pressed = "esoui/art/campaign/overview_indexicon_emperor_down.dds",
                 highlight = "esoui/art/campaign/overview_indexicon_emperor_over.dds",
                 label = "Trials Schedule",-- TODO: translate
                 callback = MenuSelector,
 
     })
     ZO_MenuBar_AddButton(self.menuBar, {
                 descriptor = name.."ButtonPledges",
                 normal = "esoui/art/contacts/tabicon_friends_up.dds",
                 pressed = "esoui/art/contacts/tabicon_friends_down.dds",
                 highlight = "esoui/art/contacts/tabicon_friends_over.dds",
                 label = "Pledges Schedule",-- TODO: translate
                 callback = MenuSelector,
     })
     ZO_MenuBar_AddButton(self.menuBar, {
                 descriptor = name.."ButtonRandomActivities",
                 normal = "/esoui/art/campaign/campaignbrowser_indexicon_specialevents_up.dds",
                 pressed = "/esoui/art/campaign/campaignbrowser_indexicon_specialevents_down.dds",
                 highlight = "/esoui/art/campaign/campaignbrowser_indexicon_specialevents_over.dds",
                 label = "Random Activities Schedule",-- TODO: translate
                 callback = MenuSelector,
     })

     ZO_MenuBar_SelectDescriptor(self.menuBar, name.."ButtonTrials")
end

function ActivitySchedule:InitializeActivitiesList()
    -- local filterComboBox = ZO_ComboBox_ObjectFromContainer(self.filterControl)
    -- filterComboBox:SetSortsItems(false)
    -- filterComboBox:SetFont("ZoFontWinT1")
    -- filterComboBox:SetSpacing(4)
    -- self.filterComboBox = filterComboBox
    -- self:BuildActivitiesList()
end



function ActivitySchedule:BuildActivitiesList()
    local entries = {{activityName = GAFE.Loc("ActivityTrials"), activityType = 'trials'}, {activityName = GAFE.Loc("ActivityPledges"), activityType = 'pledge'},}

    local function OnFilterChanged(...)
        self:OnFilterChanged(...)
    end

    for _, info in ipairs(entries) do
        local entry = ZO_ComboBox:CreateItemEntry(info.activityName, OnFilterChanged)
        entry.data =
        {
            activityType = info.activityType,
        }
        self.filterComboBox:AddItem(entry, ZO_COMBOBOX_SUPPRESS_UPDATE)
    end

    self.filterComboBox:SelectFirstItem()
end

function ActivitySchedule:OnFilterChanged(comboBox, entryText, entry)
    self.trialsSchedule:SetHidden(true)

    if entry.data.activityType=='trials' then
        self.trialsSchedule:SetHidden(false)
    end
end

function GAFE_ActivitySchedulePanel_OnInitialized(control)
    GAFE.ActivitySchedule = ActivitySchedule:New(control)
end