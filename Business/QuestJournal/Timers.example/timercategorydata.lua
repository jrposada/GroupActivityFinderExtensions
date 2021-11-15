--
-- GAFE_TimerCategory_Base
--


GAFE_TimerCategory_Base = ZO_Object:Subclass()

function GAFE_TimerCategory_Base:New(...)
    local object = ZO_Object.New(self)
    object:Initialize(...)
    return object
end

function GAFE_TimerCategory_Base:Initialize(timerCategoryId, categoryName, categoryOrder)
    self.timerCategoryId = timerCategoryId
    self.categoryOrder = categoryOrder
    self.name = categoryName
    self.gamepadIcon = nil
    self.keyboardNormalIcon = nil
    self.keyboardPressedIcon = nil
    self.keyboardMousedOverIcon = nil
    self.subcategories = {}
end

function GAFE_TimerCategory_Base:GetId()
    return self.timerCategoryId
end

function GAFE_TimerCategory_Base:GetOrder()
    return self.categoryOrder
end

function GAFE_TimerCategory_Base:GetName()
    return self.name
end

function GAFE_TimerCategory_Base:SetKeyboardIcons(normalIcon, pressedIcon, mouseOverIcon)
    self.keyboardNormalIcon = normalIcon
    self.keyboardPressedIcon = pressedIcon
    self.keyboardMousedOverIcon = mouseOverIcon
end

function GAFE_TimerCategory_Base:GetKeyboardIcons()
    return self.keyboardNormalIcon, self.keyboardPressedIcon, self.keyboardMousedOverIcon
end

function GAFE_TimerCategory_Base:SetGamepadIcon(icon)
    self.gamepadIcon = icon
end

function GAFE_TimerCategory_Base:GetGamepadIcon()
    return self.gamepadIcon
end

function GAFE_TimerCategory_Base:SetParentCategoryData(parentCategoryData)
    self.parentCategoryData = parentCategoryData
end

function GAFE_TimerCategory_Base:GetParentCategoryData()
    return self.parentCategoryData
end

function GAFE_TimerCategory_Base:HasNewLead()
    for index, antiquityData in self:AntiquityIterator() do
        if antiquityData:HasNewLead() then
            return true
        end
    end
    for index, subcategoryData in self:SubcategoryIterator() do
        if subcategoryData:HasNewLead() then
            return true
        end
    end
    return false
end

function GAFE_TimerCategory_Base:AntiquityIterator(filterFunctions)
    assert(false) -- Must be overridden
end

function GAFE_TimerCategory_Base:AddSubcategoryData(subcategoryData)
    table.insert(self.subcategories, subcategoryData)
    subcategoryData:SetParentCategoryData(self)
end

function GAFE_TimerCategory_Base:GetNumSubcategories()
    return #self.subcategories
end

function GAFE_TimerCategory_Base:SortSubcategories()
    table.sort(self.subcategories, GAFE_TimerCategory_Base.CompareTo)
    for _, subcategory in ipairs(self.subcategories) do
        subcategory:SortSubcategories()
    end
end

function GAFE_TimerCategory_Base:SubcategoryIterator(filterFunctions)
    return ZO_FilteredNumericallyIndexedTableIterator(self.subcategories, filterFunctions)
end

function GAFE_TimerCategory_Base:CompareTo(antiquityCategory)
    return self:GetOrder() < antiquityCategory:GetOrder() or (self:GetOrder() == antiquityCategory:GetOrder() and self:GetName() < antiquityCategory:GetName())
end

--
-- GAFE_TimerCategory
--

GAFE_TimerCategory = GAFE_TimerCategory_Base:Subclass()

function GAFE_TimerCategory:New(...)
    return GAFE_TimerCategory_Base.New(self, ...)
end

function GAFE_TimerCategory:Initialize(antiquityCategoryId)
    local name = GetAntiquityCategoryName(antiquityCategoryId)
    local categoryOrder = GetAntiquityCategoryOrder(antiquityCategoryId)
    GAFE_TimerCategory_Base.Initialize(self, antiquityCategoryId, name, categoryOrder)

    self:SetGamepadIcon(GetAntiquityCategoryGamepadIcon(antiquityCategoryId))

    local keyboardNormalIcon, keyboardPressedIcon, keyboardMousedOverIcon = GetAntiquityCategoryKeyboardIcons(antiquityCategoryId)
    self:SetKeyboardIcons(keyboardNormalIcon, keyboardPressedIcon, keyboardMousedOverIcon)

    self.antiquities = {}

    -- Get Parent Antiquity Category information.
    local parentCategoryId = GetAntiquityCategoryParentId(antiquityCategoryId)
    if parentCategoryId ~= 0 then
        local parentCategoryData = ANTIQUITY_DATA_MANAGER:GetOrCreateAntiquityCategoryData(parentCategoryId)
        parentCategoryData:AddSubcategoryData(self)
    end
end

function GAFE_TimerCategory:AddTimerData(antiquityData)
    table.insert(self.antiquities, antiquityData)
end

function GAFE_TimerCategory:AntiquityIterator(filterFunctions)
    return ZO_FilteredNumericallyIndexedTableIterator(self.antiquities, filterFunctions)
end

function GAFE_TimerCategory:GetNumAntiquities()
    return #self.antiquities
end

function GAFE_TimerCategory:SortAntiquities()
    table.sort(self.antiquities, ZO_DefaultAntiquityOrSetSortComparison)
end

-- override of GAFE_TimerCategory_Base:SortSubcategories()
function GAFE_TimerCategory:SortSubcategories()
    table.sort(self.subcategories, GAFE_TimerCategory.CompareTo)
    for _, subcategory in ipairs(self.subcategories) do
        subcategory:SortAntiquities()
        subcategory:SortSubcategories()
    end
end

--
-- GAFE_TimerFilterCategory
--

GAFE_TimerFilterCategory = GAFE_TimerCategory_Base:Subclass()

function GAFE_TimerFilterCategory:New(...)
    return GAFE_TimerCategory_Base.New(self, ...)
end

function GAFE_TimerFilterCategory:Initialize(...)
    GAFE_TimerCategory_Base.Initialize(self, ...)

    self.antiquityFilterFunction = nil
end

function GAFE_TimerFilterCategory:SetAntiquityFilterFunction(filterFunction)
    self.antiquityFilterFunction = filterFunction
end

function GAFE_TimerFilterCategory:AntiquityIterator(filterFunctions)
    local combinedFilterFunctions = {self.antiquityFilterFunction}
    if filterFunctions then
        ZO_CombineNumericallyIndexedTables(combinedFilterFunctions, filterFunctions)
    end

    return ANTIQUITY_DATA_MANAGER:AntiquityIterator(combinedFilterFunctions)
end

-- Global Functions

-- Sort by Discovered, Quality (ascending) and Antiquity Name (ascending).
function ZO_DefaultAntiquitySortComparison(leftAntiquityData, rightAntiquityData)
    if leftAntiquityData:HasDiscovered() ~= rightAntiquityData:HasDiscovered() then
        return leftAntiquityData:HasDiscovered()
    elseif leftAntiquityData:GetQuality() < rightAntiquityData:GetQuality() then
        return true
    elseif leftAntiquityData:GetQuality() == rightAntiquityData:GetQuality() then
        return GAFE_Timer.CompareNameTo(leftAntiquityData, rightAntiquityData)
    end

    return false
end

-- Sort by Discovered, Quality (ascending) and Set or Antiquity Name (ascending).
function ZO_DefaultAntiquityOrSetSortComparison(leftAntiquityOrSetData, rightAntiquityOrSetData)
    local leftData = leftAntiquityOrSetData:GetAntiquitySetData() or leftAntiquityOrSetData
    local rightData = rightAntiquityOrSetData:GetAntiquitySetData() or rightAntiquityOrSetData

    if leftData:HasDiscovered() ~= rightData:HasDiscovered() then
        return leftData:HasDiscovered()
    elseif leftData:GetQuality() < rightData:GetQuality() then
        return true
    elseif leftData:GetQuality() == rightData:GetQuality() then
        return GAFE_Timer.CompareSetAndNameTo(leftAntiquityOrSetData, rightAntiquityOrSetData)
    end

    return false
end