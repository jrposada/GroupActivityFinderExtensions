local GAFE = GroupActivityFinderExtensions
local WM = WINDOW_MANAGER

GAFE_TrialsSchedule = ZO_Object:Subclass()

local TrialQuest = GAFE.TrialChestTimer.TrialQuest

function GAFE_TrialsSchedule:New (...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function GAFE_TrialsSchedule:Initialize(control)

    self.control = control
    self:InitializeControls()
end

function GAFE_TrialsSchedule:InitializeControls()
    local index = 0
    for name, questId in pairs(TrialQuest) do
        local row = WM:CreateControlFromVirtual("GAFE_TrialsSchedule_Row_"..name, self.control, "GAFE_TrialsSchedule_Row")
        row:SetAnchor(TOPLEFT, self.control,TOPLEFT, 0, index * 40)

        local label = row:GetNamedChild("Label")
        label:SetText(name)
        index = index + 1
    end
end

function GAFE_TrialsSchedule:SetHidden(hidden)
    GAFE.LogLater(hidden)
    self.control:SetHidden(hidden)
end