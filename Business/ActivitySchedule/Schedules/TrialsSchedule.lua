local GAFE = GroupActivityFinderExtensions
local WM = WINDOW_MANAGER
-- local TrialQuest = GAFE.TrialChestTimer.TrialQuest

GAFE_TrialsSchedule = ZO_Object:Subclass()

function GAFE_TrialsSchedule:New (...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function GAFE_TrialsSchedule:Initialize(control)
    self.control = control

    self.label = self.control:GetNamedChild("Label")

    self:InitializeControls()
end

function GAFE_TrialsSchedule:InitializeControls()
    self:InitializeFragment()
end

function GAFE_TrialsSchedule:InitializeFragment()
    self.label:SetText('Initialized')
end

function GAFE_TrialsSchedule_Init(control)
    GAFE.ActivitySchedule = GAFE_TrialsSchedule:New(control)
end