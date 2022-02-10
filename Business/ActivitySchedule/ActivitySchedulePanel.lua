local GAFE = GroupActivityFinderExtensions
local WM = WINDOW_MANAGER

GAFE_ActivitySchedule = ZO_Object:Subclass()

function GAFE_ActivitySchedule:New (...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function GAFE_ActivitySchedule:Initialize(control)
    self.control = control

    self.trialsWindow = self.control:GetNamedChild("TrialsWindow")
    self.pledgesWindow = self.control:GetNamedChild("PledgesWindow")
    self.randomActivitiesWindow = self.control:GetNamedChild("RandomActivitiesWindow")
    self.menuBar = self.control:GetNamedChild("MenuBar")
    self.menuBarLabel = self.menuBar:GetNamedChild('Label')

    self:InitializeControls()
end

function GAFE_ActivitySchedule:InitializeControls()
    self:InitializeFragment()
end

function GAFE_ActivitySchedule:InitializeFragment()
    self:InitializeMenuBar()
end

function GAFE_ActivitySchedule:InitializeMenuBar()
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

function GAFE_ActivitySchedulePanel_OnInitialized(control)
    GAFE.ActivitySchedule = GAFE_ActivitySchedule:New(control)
end