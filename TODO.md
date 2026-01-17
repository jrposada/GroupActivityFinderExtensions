Port the following feature, copied form InventoryExtensions addon into src/modules/inventory.

This feature replaces price shown in inventory for TTC addon price. Its an optional feature dependincg both on config saved vars and TTC addon been installed.

```
local AGS = AwesomeGuildStore
local TTC = TamrielTradeCentre
local TTCPrice = TamrielTradeCentrePrice
local Controls = LibPanicida.Controls

local currencyOptions = {
    showTooltips = false,
    font = "ZoFontGameShadow",
    iconSide = RIGHT,
    color = ZO_ColorDef:New(1, 0.84, 0, 1),
}

local armoryBuildIconIndexByBuildName = {}

local function SetPriceControl(link, control)
    local isBound = IsItemLinkBound(link)
    local priceInfo = TTCPrice:GetPriceInfo(link)

    if priceInfo then
        local ttcPriceSaleAvg = priceInfo.SaleAvg or priceInfo.Avg
        local ttcPriceSuggestedPrice = priceInfo.SuggestedPrice or priceInfo.Avg

        -- Use suggested
        local ttcUnitItemPrice = ttcPriceSuggestedPrice
        if ttcPriceSaleAvg < ttcPriceSuggestedPrice then
            -- unless sale avg is less
            ttcUnitItemPrice = ttcPriceSaleAvg
        end
        if isBound or not ttcUnitItemPrice then
            return
        end


        if not isBound and ttcUnitItemPrice then
            local sellPriceControl = control:GetNamedChild("SellPriceText")
            ZO_CurrencyControl_SetSimpleCurrency(sellPriceControl, CURT_MONEY, math.floor(ttcUnitItemPrice),
                currencyOptions)
        end
    end
end

local function GetMarginData(data, itemLink)
    local ttcPriceInfo = TTCPrice:GetPriceInfo(itemLink)

    if not ttcPriceInfo then
        return
    end

    local ttcPriceSaleAvg = ttcPriceInfo.SaleAvg or ttcPriceInfo.Avg
    local ttcPriceSuggestedPrice = ttcPriceInfo.SuggestedPrice or ttcPriceInfo.Avg

    -- Use suggested
    local ttcUnitItemPrice = ttcPriceSuggestedPrice
    if ttcPriceSaleAvg < ttcPriceSuggestedPrice then
        -- unless sale avg is less
        ttcUnitItemPrice = ttcPriceSaleAvg
    end

    local stackCount = data:GetStackCount()
    local purchasePrice = data.purchasePrice
    local profit = ttcUnitItemPrice * stackCount - purchasePrice
    local unitProfit = ttcUnitItemPrice - purchasePrice / stackCount
    local profitMargin = (profit) * 100 / ttcUnitItemPrice -- in %

    return ttcUnitItemPrice, profit, unitProfit, profitMargin, stackCount
end

local function SetSearchPriceControl(link, control, result)
    local isBound = IsItemLinkBound(link)
    local ttcUnitItemPrice, profit, unitProfit, profitMargin, stackCount = GetMarginData(result, link)

    if isBound or not ttcUnitItemPrice then
        return
    end

    local perItemPriceControl = control.perItemPrice
    local sellPriceControl = control.sellPriceControl

    local formattedProfit = ZO_CurrencyControl_FormatAndLocalizeCurrency(
        zo_roundToNearest(profit, 0.01),
        profit >= 100000
    )
    local formattedUnitProfit = ZO_CurrencyControl_FormatAndLocalizeCurrency(
        zo_roundToNearest(unitProfit, 0.01),
        unitProfit >= 100000
    )

    if (profitMargin <= 20 or profit < 3000) then
        return
    elseif profitMargin <= 35 then
        formattedProfit = "|c32CD32+" .. formattedProfit .. "|r"         -- green
        formattedUnitProfit = "|c32CD32+" .. formattedUnitProfit .. "|r" -- green
    elseif profitMargin <= 50 then
        formattedProfit = "|c398df7+" .. formattedProfit .. "|r"         -- blue
        formattedUnitProfit = "|c398df7+" .. formattedUnitProfit .. "|r" -- blue
    elseif profitMargin <= 65 then
        formattedProfit = "|c9e2df4+" .. formattedProfit .. "|r"         -- purple
        formattedUnitProfit = "|c9e2df4+" .. formattedUnitProfit .. "|r" -- purple
    else
        formattedProfit = "|cFFD700+" .. formattedProfit .. "|r"         -- gold
        formattedUnitProfit = "|cFFD700+" .. formattedUnitProfit .. "|r" -- gold
    end

    -- FIXME: fix writs prices. Stacks are counted per writ instead per item. So prices are inflated.

    sellPriceControl:SetText(formattedProfit ..
        " - " .. sellPriceControl:GetText():gsub("|t.-:.-:", "|t14:14:"))

    if stackCount > 1 then
        perItemPriceControl:SetText("@" ..
            formattedUnitProfit .. " - " .. perItemPriceControl:GetText():gsub("|t.-:.-:", "|t14:14:"):gsub("@", ""))
    end
end

local function SetCraftedIcon(link, control)
    local isCrafted = IsItemLinkCrafted(link)
    local isConsumable = IsItemLinkConsumable(link)

    if isConsumable and isCrafted then
        local traitInfoControl = control:GetNamedChild("TraitInfo")
        traitInfoControl:ClearIcons()

        traitInfoControl:AddIcon("esoui/art/icons/poi/poi_crafting_complete.dds")
        traitInfoControl:Show()
    end
end

local function SetArmoryInfo(slot, control)
    if IsItemInArmory(slot.bagId, slot.slotIndex) then
        local armoryBuildList = { GetItemArmoryBuildList(slot.bagId, slot.slotIndex) }

        if #armoryBuildList == 0 then
            return
        end

        local armoryControl = Controls.MultiIcon(
            control:GetName() .. "Armory",
            control,
            { 32, 32 },
            { RIGHT, control:GetNamedChild("TraitInfo"), RIGHT, -37, 0 }
        )

        if armoryControl == nil then
            return
        end

        armoryControl:ClearIcons()

        local tooltipLines = {}
        for _, buildName in ipairs(armoryBuildList) do
            local buildIconIndex = armoryBuildIconIndexByBuildName[buildName];
            local buildIcon = string.format(ZO_ARMORY_BUILD_ICON_TEXTURE_FORMATTER, buildIconIndex)
            table.insert(tooltipLines, buildName)
            armoryControl:AddIcon(buildIcon)
        end

        if #tooltipLines ~= 0 then
            Controls.SetTooltip(
                armoryControl,
                tooltipLines
            )
        end

        armoryControl:SetDrawTier(DT_HIGH)
        armoryControl:Show()
    else
        local armoryControl = control:GetNamedChild("Armory")
        if armoryControl then
            armoryControl:ClearIcons()
        end
    end


end

local function ExtendInventorySlot(control, slot)
    local link = GetItemLink(slot.bagId, slot.slotIndex)
    if link == nil or not TTC:IsItemLink(link) then
        return
    end

    SetPriceControl(link, control)
    SetCraftedIcon(link, control)
    SetArmoryInfo(slot, control)
end

local function OverrideStoreSearchPrice(control, result)
    local inventorySlot = ZO_InventorySlot_GetInventorySlotComponents(control)
    local slotType = ZO_InventorySlot_GetType(inventorySlot)
    if slotType ~= SLOT_TYPE_TRADING_HOUSE_ITEM_RESULT then
        return
    end

    local tradingHouseIndex = ZO_Inventory_GetSlotIndex(inventorySlot)
    local link = GetTradingHouseSearchResultItemLink(tradingHouseIndex)
    if link == nil or not TTC:IsItemLink(link) then
        return
    end

    SetSearchPriceControl(link, control, result)
end

local function InitInventory(dataType)
    if dataType then
        ZO_PostHook(
            dataType,
            "setupCallback",
            function(control, slot)
                ExtendInventorySlot(control, slot)
            end
        )
    end
end

local function InitStoreSearch(dataType)
    if dataType then
        ZO_PostHook(
            dataType,
            "setupCallback",
            function(control, slot)
                OverrideStoreSearchPrice(control, slot)
            end
        )
    end
end

local STEPS = {
    { id = 1, value = -math.huge },
    { id = 2, value = 20 },
    { id = 3, value = 35 },
    { id = 4, value = 50 },
    { id = 5, value = 65 }
}

local function InitAGSIntegration(tradingHouseWrapper)
    for i = 1, #STEPS do
        local value = STEPS[i]
        value.label = "<= " .. value.value .. "%"
    end

    -- Filter is constant of 104. Leaving this for compatibility until the AGS update releases.
    -- local SUBFILTER_ATT        = AwesomeGuildStore.data.FILTER_ID.ARKADIUS_TRADE_TOOLS_DEAL_FILTER or 104
    local SUBFILTER_ATT        = 1001
    local FilterBase           = AGS.class.FilterBase
    local ValueRangeFilterBase = AGS.class.ValueRangeFilterBase
    local FILTER_ID            = AGS.data.FILTER_ID
    local SUB_CATEGORY_ID      = AGS.data.SUB_CATEGORY_ID
    local MIN_VALUE            = 1
    local MAX_VALUE            = 5
    local AGSFilter            = ValueRangeFilterBase:Subclass()

    function AGSFilter:New(...)
        return ValueRangeFilterBase.New(self, ...)
    end

    function AGSFilter:ResetCache()
        self.averagePrices = {}
    end

    function AGSFilter:Initialize()
        self.averagePrices = {}
        ValueRangeFilterBase.Initialize(
            self
            , SUBFILTER_ATT
            , FilterBase.GROUP_LOCAL
            , {
                label = 'Deal Finder'
                ,
                min = MIN_VALUE
                ,
                max = MAX_VALUE
                ,
                steps = STEPS
            }
        )
        local qualityById = {}
        for i = 1, #self.config.steps do
            local step = self.config.steps[i]
            local color = i == 1 and ZO_ColorDef:New(1, 0, 0) or GetItemQualityColor(step.id)
            step.color = color
            step.colorizedLabel = color:Colorize(step.label)
            qualityById[step.id] = step
        end
        self.qualityById = qualityById
    end

    function AGSFilter:CanFilter(...)
        return true
    end

    function AGSFilter:ForceUpdate()
        self:HandleChange(self.min, self.max)
    end

    function AGSFilter:IsDefaultDealLevel(margin)
        -- return (margin == -math.huge and Settings.defaultDealLevel >= self.min and Settings.defaultDealLevel <= self.max and Settings.defaultDealLevel >= self.min and Settings.defaultDealLevel <= self.max)
        return true
    end

    function AGSFilter:IsWithinDealRange(profit, margin)
        return margin ~= nil and profit ~= nil and profit >= 3000 and
            ((margin ~= -math.huge) and (margin >= STEPS[self.min].value) and (self.max == MAX_VALUE or margin < STEPS[self.max + 1].value))
    end

    function AGSFilter:FilterLocalResult(data)
        local itemLink = GetTradingHouseSearchResultItemLink(data.slotIndex)
        if not itemLink then return false end
        -- local days = ArkadiusTradeToolsSales.TradingHouse:GetCalcDays()
        -- local margin = GetMarginData(self.averagePrices, data, itemLink, days)
        -- return self:IsWithinDealRange(margin) or self:IsDefaultDealLevel(margin)
        local ttcUnitItemPrice, profit, unitProfit, profitMargin = GetMarginData(data, itemLink)
        return self:IsWithinDealRange(profit, profitMargin)
    end

    function AGSFilter:IsLocal()
        return true
    end

    function AGSFilter:GetTooltipText(min, max)
        if (min ~= self.config.min or max ~= self.config.max) then
            local out = {}
            for id = min, max do
                local step = self.qualityById[id]
                out[#out + 1] = step.colorizedLabel
            end
            return table.concat(out, ", ")
        end
        return ""
    end

    local filter = AGSFilter:New()
    -- We need to register both the filter function and the actual UI fragment before it'll show up in AGS
    AGS:RegisterFilter(filter)
    AGS:RegisterFilterFragment(AGS.class.QualityFilterFragment:New(SUBFILTER_ATT))
    EVENT_MANAGER:RegisterForEvent(INVENTORY_EXTENSIONS.name, EVENT_CLOSE_TRADING_HOUSE,
        function() filter:ResetCache() end)
end

local function Init()
    local savedVars = INVENTORY_EXTENSIONS.SavedVars

    local numBuilds = GetNumUnlockedArmoryBuilds()
    for index = 1, numBuilds do
        local buildName = GetArmoryBuildName(index)
        local buildIconIndex = GetArmoryBuildIconIndex(index)
        armoryBuildIconIndexByBuildName[buildName] = buildIconIndex
    end

    if TTC and savedVars.ttcPrice.enabled then
        InitInventory(ZO_PlayerInventoryList.dataTypes[1])
        InitInventory(ZO_PlayerBankBackpack.dataTypes[1])
        InitInventory(ZO_CraftBagList.dataTypes[1])

        if AGS then
            local originalAgsInitializeResultList = AGS.class.SearchResultListWrapper.InitializeResultList
            AGS.class.SearchResultListWrapper.InitializeResultList = function(self, tradingHouseWrapper, searchManager)
                originalAgsInitializeResultList(self, tradingHouseWrapper, searchManager)
                local searchResultDataType = ZO_ScrollList_GetDataTypeTable(self.list.list, 1)
                InitStoreSearch(searchResultDataType)
            end

            AGS:RegisterCallback(AGS.callback.AFTER_FILTER_SETUP, InitAGSIntegration)
            -- ZO_PostHook(AwesomeGuildStore.class.SellTabWrapper, 'InitializeListingInput',
            --     function() self:AddAGSPriceButton() end)
        end
    end
end

IE_TTC_PRICE = {}

function IE_TTC_PRICE.Init()
    Init()
end

function IE_TTC_PRICE.Enable(enable)
    local savedVars = INVENTORY_EXTENSIONS.SavedVars

    savedVars.ttcPrice.enabled = enable
end

```

Implement this feature as ttc-price. Follow same pattern as other inventory extensions by coding it on it's own file.

Update README after feature is implemented.
