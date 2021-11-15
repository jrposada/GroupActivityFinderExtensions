GAFE_TimerDataManager = ZO_CallbackObject:Subclass()

function GAFE_TimerDataManager:New(...)
    TIMER_DATA_MANAGER = ZO_CallbackObject.New(self)
    TIMER_DATA_MANAGER:Initialize(...)
    return TIMER_DATA_MANAGER
end

function GAFE_TimerDataManager:Initialize()
    self.antiquities = {}
    self.antiquityCategories = {}
    self.antiquitySets = {}
    self.topLevelCategories = {}

    self:InitializeEventHandlers()
    self:RebuildAntiquities()
end

function GAFE_TimerDataManager:InitializeEventHandlers()
    local function OnTimersUpdated()
        self:RefreshAll()
    end

    local function OnSingleTimerUpdated(event, antiquityId)
        self:RefreshTimer(antiquityId)
    end

    local function OnSingleAntiquityDigSitesUpdated(event, antiquityId)
        self:OnSingleAntiquityDigSitesUpdated(antiquityId)
    end

    local function OnAntiquitySearchResultsReady()
        self:UpdateSearchResults()
    end

    local function OnSkillsUpdated()
        self:OnSkillsUpdated()
    end

    local function OnAntiquityLeadAcquired(event, antiquityId)
        self:OnSingleAntiquityLeadAcquired(antiquityId)
    end

    local function OnAntiquityShowCodexEntry(event, antiquityId)
        self:OnAntiquityShowCodexEntry(antiquityId)
    end

    -- EVENT_MANAGER:RegisterForEvent("TimersDataManager", EVENT_ANTIQUITIES_UPDATED, OnAntiquitiesUpdated)

    -- TODO: Register for events that requiere to update the timers value, like quest complitions and such.
end

-- ZO_AntiquityCategory

function GAFE_TimerDataManager:AntiquityCategoryIterator(filterFunctions)
    return ZO_FilteredNonContiguousTableIterator(self.antiquityCategories, filterFunctions)
end

function GAFE_TimerDataManager:ClearTimerCategories()
    ZO_ClearTable(self.antiquityCategories)
end

function GAFE_TimerDataManager:ClearTopLevelCategories()
    ZO_ClearNumericallyIndexedTable(self.topLevelCategories)
end

-- function ZO_AntiquityDataManager:GetAntiquityCategoryData(antiquityCategoryId)
--     return self.antiquityCategories[antiquityCategoryId]
-- end

-- Internal function
-- function ZO_AntiquityDataManager:GetOrCreateAntiquityCategoryData(antiquityCategoryId)
--     if antiquityCategoryId and antiquityCategoryId ~= ZO_SCRYABLE_ANTIQUITY_CATEGORY_ID then
--         local antiquityCategoryData = self:GetAntiquityCategoryData(antiquityCategoryId)
--         if not antiquityCategoryData then
--             antiquityCategoryData = ZO_AntiquityCategory:New(antiquityCategoryId)
--             self.antiquityCategories[antiquityCategoryId] = antiquityCategoryData
--             if not antiquityCategoryData:GetParentCategoryData() then
--                 table.insert(self.topLevelCategories, antiquityCategoryData)
--             end
--         end
--         return antiquityCategoryData
--     end
-- end

-- function ZO_AntiquityDataManager:TopLevelAntiquityCategoryIterator(filterFunctions)
--     return ZO_FilteredNumericallyIndexedTableIterator(self.topLevelCategories, filterFunctions)
-- end

-- function ZO_AntiquityDataManager:SortTopLevelAntiquityCategories()
--     table.sort(self.topLevelCategories, ZO_AntiquityCategory.CompareTo)
--     for _, antiquityCategoryData in ipairs(self.topLevelCategories) do
--         antiquityCategoryData:SortAntiquities()
--         antiquityCategoryData:SortSubcategories()
--     end
-- end

-- ZO_AntiquitySet

-- function ZO_AntiquityDataManager:AntiquitySetIterator(filterFunctions)
--     return ZO_FilteredNonContiguousTableIterator(self.antiquitySets, filterFunctions)
-- end

-- function ZO_AntiquityDataManager:ClearAntiquitySets()
--     ZO_ClearTable(self.antiquitySets)
-- end

-- function ZO_AntiquityDataManager:GetAntiquitySetData(antiquitySetId)
--     return self.antiquitySets[antiquitySetId]
-- end

-- function ZO_AntiquityDataManager:GetOrCreateAntiquitySetData(antiquitySetId)
--     if antiquitySetId and antiquitySetId ~= 0 then
--         local antiquitySetData = self:GetAntiquitySetData(antiquitySetId)
--         if not antiquitySetData then
--             antiquitySetData = ZO_AntiquitySet:New(antiquitySetId)
--             self.antiquitySets[antiquitySetId] = antiquitySetData
--         end
--         return antiquitySetData
--     end
-- end

-- ZO_Antiquity

-- function ZO_AntiquityDataManager:AntiquityIterator(filterFunctions)
--     return ZO_FilteredNonContiguousTableIterator(self.antiquities, filterFunctions)
-- end

-- function ZO_AntiquityDataManager:ClearAntiquities()
--     ZO_ClearTable(self.antiquities)
-- end

-- function ZO_AntiquityDataManager:GetAntiquityData(antiquityId)
--     return self.antiquities[antiquityId]
-- end

-- function ZO_AntiquityDataManager:GetOrCreateAntiquityData(antiquityId)
--     if antiquityId and antiquityId ~= 0 then
--         local antiquityData = self:GetAntiquityData(antiquityId)
--         if not antiquityData then
--             antiquityData = ZO_Antiquity:New(antiquityId)
--             self.antiquities[antiquityId] = antiquityData
--         end
--         return antiquityData
--     end
-- end

-- function ZO_AntiquityDataManager:RefreshTimer(antiquityId)
--     local antiquityData = self:GetAntiquityData(antiquityId)
--     if antiquityData then
--         antiquityData:Refresh()
--         self:SortTopLevelAntiquityCategories()
--         self:FireCallbacks("SingleAntiquityUpdated", antiquityData)
--     else
--         internalassert(false, string.format("Invalid antiquityId (%s)", tostring(antiquityId) or "nil"))
--     end
-- end

-- function ZO_AntiquityDataManager:OnAntiquityShowCodexEntry(antiquityId)
--     if IsInGamepadPreferredMode() then
--         local DONT_PUSH = false
--         local antiquityData = self:GetAntiquityData(antiquityId)
--         internalassert(antiquityData ~= nil)
--         if antiquityData then
--             ANTIQUITY_LORE_GAMEPAD:SetFromFanfare(true)
--             ANTIQUITY_LORE_GAMEPAD:ShowAntiquityOrSet(antiquityData, DONT_PUSH)
--         end
--     else
--         local categoryId = GetAntiquityCategoryId(antiquityId)
--         ANTIQUITY_JOURNAL_KEYBOARD:ShowCategory(categoryId)
--         ANTIQUITY_LORE_KEYBOARD:ShowAntiquity(antiquityId)
--     end
-- end

-- function GAFE_TimerDataManager:RefreshAll()
--     for _, antiquityData in self:AntiquityIterator() do
--         antiquityData:Refresh()
--     end
--     self:SortTopLevelAntiquityCategories()
--     self:FireCallbacks("AntiquitiesUpdated")
-- end

-- function GAFE_TimerDataManager:RebuildTimers()
--     self:ClearTimers()
--     self:ClearAntiquityCategories()
--     self:ClearAntiquitySets()
--     self:ClearTopLevelCategories()

--     -- Load all Antiquities and their associated objects.
--     local antiquityId = GetNextAntiquityId()
--     while antiquityId do
--         self:GetOrCreateAntiquityData(antiquityId)
--         antiquityId = GetNextAntiquityId(antiquityId)
--     end

--     self:SortTopLevelAntiquityCategories()
--     self:FireCallbacks("AntiquitiesUpdated")
-- end

-- Global singleton

-- The global singleton moniker is assigned by the Data Manager's constructor in order to
-- allow data objects to reference the singleton during their construction.
GAFE_TimerDataManager:New()
