local GAFE_QuestsTimersManager = ZO_Object:Subclass()

function GAFE_QuestsTimersManager:New(control)
    local manager = ZO_Object.New(self)
    manager.control = control

    -- manager.zoneInfoContainer = control:GetNamedChild("ZoneInfoContainer")
    -- manager.zoneStepContainer = control:GetNamedChild("ZoneStepContainer")
    -- manager.titleText = control:GetNamedChild("TitleText")
    -- manager.descriptionText = control:GetNamedChild("DescriptionText")
    -- manager.objectivesText = control:GetNamedChild("ObjectivesText")
    -- manager.objectiveLinePool = ZO_ControlPool:New("ZO_Cadwell_ObjectiveLine", control, "Objective")

    -- manager.currentCadwellProgressionLevel = GetCadwellProgressionLevel()

    -- manager:InitializeCategoryList(control)
    -- manager:RefreshList()

    -- local function OnCadwellProgressionLevelChanged(event, cadwellProgression)
    --     MAIN_MENU_KEYBOARD:UpdateSceneGroupButtons("journalSceneGroup")
    --     manager.currentCadwellProgressionLevel = cadwellProgression
    --     manager:RefreshList()
    -- end

    -- local function OnPOIUpdated()
    --     if manager.currentCadwellProgressionLevel > CADWELL_PROGRESSION_LEVEL_BRONZE then
    --         manager:RefreshList()
    --     end
    -- end

    -- control:RegisterForEvent(EVENT_POI_UPDATED, OnPOIUpdated)
    -- control:RegisterForEvent(EVENT_CADWELL_PROGRESSION_LEVEL_CHANGED, OnCadwellProgressionLevelChanged)

    return manager
end

function GAFE_QuestsTimersManager:OnShown()
    if self.dirty then
        self:RefreshList()
        self.dirty = false
    end
end

--XML Handlers

function GAFE_QuestsTimers_OnShown()
    GAFE_QUESTS_TIMERS:OnShown()
end

function GAFE_QuestsTimers_Initialize(control)
    GAFE_QUESTS_TIMERS = GAFE_QuestsTimersManager:New(control)
end
