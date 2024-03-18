local MAX_ESCORTS_SHOWN = 6
local MIN_MET_TEXTURE = "EsoUI/Art/AvA/AvA_ram_slot_green.dds"
local MIN_NOT_MET_TEXTURE = "EsoUI/Art/AvA/AvA_ram_slot_red.dds"
local SPOT_NOT_FILLED_TEXTURE = "EsoUI/Art/AvA/AvA_ram_slot_empty.dds"

GAFE_Ram = ZO_Object:Subclass()

function GAFE_Ram:New(control)
    local object = ZO_Object.New(self)
    object:Initialize(control)
    return object
end

function GAFE_Ram:Initialize(control)
    self.control = control
    self.name = control:GetNamedChild("Name")
    self.indicatorsControl = control:GetNamedChild("Indicators")
    self.indicatorsList = {}

    local prevControl
    for i = 1, MAX_ESCORTS_SHOWN do
        local currentControl = CreateControlFromVirtual("GAFE_RamIndicators", self.indicatorsControl, "ZO_RamIndicator", i)
        self.indicatorsList[i] = currentControl
        if(prevControl) then
            currentControl:SetAnchor(TOPLEFT, prevControl, TOPRIGHT)
        else
            currentControl:SetAnchor(TOPLEFT, nil, TOPLEFT)
        end
        prevControl = currentControl
    end

    ZO_StatusBar_SetGradientColor(ZO_RamHealth, ZO_POWER_BAR_GRADIENT_COLORS[COMBAT_MECHANIC_FLAGS_HEALTH])

    local function OnRamEscortCountUpdate(eventCode, numEscorts)
        self:UpdateRam(numEscorts)
    end

    local function OnLeaveRamEscort()
        self.isInitialized = false
        self:UpdateVisibility()
    end

    control:RegisterForEvent(EVENT_RAM_ESCORT_COUNT_UPDATE, OnRamEscortCountUpdate)
    control:RegisterForEvent(EVENT_LEAVE_RAM_ESCORT, OnLeaveRamEscort)

    self:UpdateRam()
end

function GAFE_Ram:UpdateRam(numEscorts)
    if not self.isInitialized then
        self.name:SetText(zo_strformat(SI_SIEGE_BAR_NAME, GetRawUnitName("escortedram")))
        self.isInitialized = true
    end

    self:UpdateNumEscorts(numEscorts or GetNumPlayersEscortingRam())

    self:UpdateVisibility()
end

function GAFE_Ram:UpdateNumEscorts(numEscorts)
    local minRequiredEscorts, maxPossibleEscorts = GetMinMaxRamEscorts()
    local spotFilledTexture = (numEscorts >= minRequiredEscorts) and MIN_MET_TEXTURE or MIN_NOT_MET_TEXTURE

    for i = 1, MAX_ESCORTS_SHOWN do
        local control = self.indicatorsList[i]
        if(i <= maxPossibleEscorts) then
            control:SetHidden(false)
            if(i <= numEscorts) then
                control:SetTexture(spotFilledTexture)
            else
                control:SetTexture(SPOT_NOT_FILLED_TEXTURE)
            end
        else
            control:SetHidden(true)
        end
    end
end

function GAFE_Ram:UpdateVisibility()
    self.control:SetHidden(not IsPlayerEscortingRam())
end

function GAFE_Ram_Initialize(control)
    GAFE_RAM = GAFE_Ram:New(control)
end
