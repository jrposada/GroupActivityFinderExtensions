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
    self.dailiesWindow = self.control:GetNamedChild("DailiesWindow")
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
        self.dailiesWindow:SetHidden(data.descriptor ~= name.."DailiesWindow")
        self.menuBarLabel:SetText( data.label )
    end

    local name = self.menuBar:GetName()
    ZO_MenuBar_AddButton(self.menuBar, {
        descriptor = name.."DailiesWindow",
        normal = "/esoui/art/campaign/campaignbrowser_indexicon_specialevents_up.dds",
        pressed = "/esoui/art/campaign/campaignbrowser_indexicon_specialevents_down.dds",
        highlight = "/esoui/art/campaign/campaignbrowser_indexicon_specialevents_over.dds",
        label = GAFE.Loc("DailiesSchedule"),
        callback = MenuSelector,
    })
    ZO_MenuBar_AddButton(self.menuBar, {
        descriptor = name.."ButtonPledges",
        normal = "/esoui/art/lfg/lfg_indexicon_dungeon_up.dds",
        pressed = "/esoui/art/lfg/lfg_indexicon_dungeon_down.dds",
        highlight = "/esoui/art/lfg/lfg_indexicon_dungeon_over.dds",
        label = GAFE.Loc("PledgesSchedule"),
        callback = MenuSelector,
    })
    -- ZO_MenuBar_AddButton(self.menuBar, {
    --     descriptor = name.."ButtonTrials",
    --     normal = "/esoui/art/lfg/lfg_indexicon_trial_up.dds",
    --     pressed = "/esoui/art/lfg/lfg_indexicon_trial_down.dds",
    --     highlight = "/esoui/art/lfg/lfg_indexicon_trial_over.dds",
    --     label = "Trials Schedule",
    --     callback = MenuSelector,
    -- })

    ZO_MenuBar_SelectDescriptor(self.menuBar, name.."DailiesWindow")
end

function GAFE_ActivitySchedulePanel_OnInitialized(control)
    GAFE.ActivitySchedule = GAFE_ActivitySchedule:New(control)
end
