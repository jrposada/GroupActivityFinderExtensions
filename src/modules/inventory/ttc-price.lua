-------------------------------------------------------------------------------
-- TTC Price Module
-- Replaces inventory prices with TTC market prices and adds profit margin
-- display in guild store search results.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Localized Globals
-------------------------------------------------------------------------------
local AwesomeGuildStore = AwesomeGuildStore
local MasterMerchant = MasterMerchant
local CURT_MONEY = CURT_MONEY
local GetItemLink = GetItemLink
local MasterMerchant = MasterMerchant
local TamrielTradeCentre = TamrielTradeCentre
local TamrielTradeCentrePrice = TamrielTradeCentrePrice
local ZO_CurrencyControl_SetSimpleCurrency = ZO_CurrencyControl_SetSimpleCurrency

local GAFE = GroupActivityFinderExtensions

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local PRICE_THRESHOLDS = {
  { threshold = 100000, color = ZO_ColorDef:New(1, 0.843, 0) },         -- Gold: > 100k
  { threshold = 20000,  color = ZO_ColorDef:New(0.620, 0.176, 0.957) }, -- Purple: 20k-100k
  { threshold = 5000,   color = ZO_ColorDef:New(0.224, 0.553, 0.969) }, -- Blue: 5k-20k
  { threshold = 0,      color = ZO_ColorDef:New(0.196, 0.804, 0.196) }, -- Green: < 5k
}
local SELL_PRICE_LABEL_OFFSET_X = -5
local SELL_PRICE_LABEL_OFFSET_Y = -8
local SELL_UNIT_PRICE_LABEL_OFFSET_X = 0
local SELL_UNIT_PRICE_LABEL_OFFSET_Y = 0
local PER_UNIT_LABEL_SUFFIX = "PerUnit"
local AVERAGE_PRICE_TEXTURE = "EsoUI/Art/Guild/tabIcon_roster_%s.dds"
local LISTING_INPUT_BUTTON_SIZE = 24

-------------------------------------------------------------------------------
-- Module Declaration
-------------------------------------------------------------------------------
local TTCPrice = {}

-------------------------------------------------------------------------------
-- Private Functions
-------------------------------------------------------------------------------

--- Gets the color for a given margin value.
--- @param price number The item price
--- @return any color The color code, or nil if below threshold
local function GetPriceColor(price)
  for _, entry in ipairs(PRICE_THRESHOLDS) do
    if price > entry.threshold then
      return entry.color
    end
  end

  return PRICE_THRESHOLDS[#PRICE_THRESHOLDS].color
end

--- Gets the TTC price for an item link.
--- @param itemLink string The item link to look up
--- @return number|nil price The TTC suggested price, or nil if not available
local function GetTTCPrice(itemLink)
  local priceInfo = TamrielTradeCentrePrice:GetPriceInfo(itemLink)

  if not priceInfo then
    return nil
  end

  local ttcPriceSaleAvg = priceInfo.SaleAvg or priceInfo.Avg
  local ttcPriceSuggestedPrice = priceInfo.SuggestedPrice or priceInfo.Avg

  local ttcUnitItemPrice = ttcPriceSuggestedPrice
  if ttcPriceSaleAvg < ttcPriceSuggestedPrice then
    ttcUnitItemPrice = ttcPriceSaleAvg
  end

  if not ttcUnitItemPrice then
    return nil
  end

  return ttcUnitItemPrice
end

local function FitStackLabel(sellPriceControl, stackCount)
  sellPriceControl:ClearAnchors()
  local parent = sellPriceControl:GetParent()

  if stackCount > 1 then
    sellPriceControl:SetAnchor(
      RIGHT,
      parent,
      RIGHT,
      SELL_PRICE_LABEL_OFFSET_X,
      SELL_PRICE_LABEL_OFFSET_Y
    )
  else
    sellPriceControl:SetAnchor(RIGHT,
      parent,
      RIGHT,
      SELL_PRICE_LABEL_OFFSET_X,
      0
    )
  end
end

--- Updates the per-unit price label visibility and content.
--- @param sellPriceControl any The sell price control
--- @param price number The TTC price per unit, or nil to hide
--- @param color any The color to use for the price
local function UpdatePerUnitLabel(sellPriceControl, stackCount, price, color)
  local hidden = stackCount <= 1
  local formattedPrice = ZO_CurrencyControl_FormatCurrency(
    price,
    true
  )
  -- TODO: use ZO_CurrencyTemplate instead of label?
  LibPanicida.Controls.Label(
    sellPriceControl:GetName() .. PER_UNIT_LABEL_SUFFIX,
    sellPriceControl,
    { 87 },
    {
      TOPRIGHT,
      sellPriceControl,
      BOTTOMRIGHT,
      SELL_UNIT_PRICE_LABEL_OFFSET_X,
      SELL_UNIT_PRICE_LABEL_OFFSET_Y
    },
    "ZoFontGameSmall",
    color,
    { TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER },
    "@" .. formattedPrice,
    hidden
  )
end

--- Sets the price control to display TTC price instead of vendor price.
--- @param control any The inventory row control
--- @param slot table The slot data containing bag and slot info
local function SetTTCPrice(control, slot)
  local sellPriceControl = control:GetNamedChild("SellPriceText")
  if not sellPriceControl then
    return
  end

  if MasterMerchant and MasterMerchant.systemSavedVariables and MasterMerchant.systemSavedVariables.replaceInventoryValues then
    -- MasterMerchant has Price override enabled. Restore control to default.

    FitStackLabel(sellPriceControl, 1)
    UpdatePerUnitLabel(sellPriceControl, 1, slot.sellPrice)
    return
  end

  local itemLink = GetItemLink(slot.bagId, slot.slotIndex)
  if not itemLink or not TamrielTradeCentre:IsItemLink(itemLink) then
    FitStackLabel(sellPriceControl, slot.stackCount)
    UpdatePerUnitLabel(sellPriceControl, slot.stackCount, slot.sellPrice)
    return
  end

  local isBound = IsItemLinkBound(itemLink)
  if isBound then
    FitStackLabel(sellPriceControl, slot.stackCount)
    UpdatePerUnitLabel(sellPriceControl, slot.stackCount, slot.sellPrice)
    return
  end

  local ttcPrice = GetTTCPrice(itemLink)
  if not ttcPrice then
    FitStackLabel(sellPriceControl, slot.stackCount)
    UpdatePerUnitLabel(sellPriceControl, slot.stackCount, slot.sellPrice)
    return
  end

  local color = GetPriceColor(ttcPrice)
  ZO_CurrencyControl_SetSimpleCurrency(
    sellPriceControl,
    CURT_MONEY,
    ttcPrice * slot.stackCount,
    {
      showTooltips = false,
      font = ZO_KEYBOARD_CURRENCY_OPTIONS.font,
      iconSide = ZO_KEYBOARD_CURRENCY_OPTIONS.iconSide,
      color = color
    },
    CURRENCY_SHOW_ALL
  )

  FitStackLabel(sellPriceControl, slot.stackCount)
  UpdatePerUnitLabel(sellPriceControl, slot.stackCount, ttcPrice,
    { color.r, color.g, color.b, color.a })
end

local function AGSInitializeListingInput(self, tradingHouseWrapper)
  local ToggleButton = AwesomeGuildStore.class.ToggleButton
  local buttonContainer = self.priceButtonContainer

  local lastSellPriceControl = buttonContainer:GetNamedChild(
    "LastSellPriceButton"
  )
  local averagePriceControl = buttonContainer:GetNamedChild("AveragePriceButton")

  local anchorControl = averagePriceControl or lastSellPriceControl
  local ttcPriceButton = ToggleButton:New(
    buttonContainer,
    "$(parent)TTCPriceButton",
    AVERAGE_PRICE_TEXTURE, 0, 0,
    LISTING_INPUT_BUTTON_SIZE,
    LISTING_INPUT_BUTTON_SIZE,
    GAFE.Loc("SetTTCPrice")
  )
  ttcPriceButton.control:ClearAnchors()
  ttcPriceButton.control:SetAnchor(
    RIGHT,
    anchorControl,
    LEFT,
    0,
    0
  )
  ttcPriceButton.control:SetDrawLayer(DL_OVERLAY) -- need to set it on every button now
  ttcPriceButton.HandlePress = function(button)
    local ttcPrice = GetTTCPrice(self.pendingItemLink)
    if (ttcPrice) then
      self:SetUnitPrice(ttcPrice)
    end
  end
end

local function InitAGSSetTTCPrice()
  if not GAFE.SavedVars.beta then
    return
  end

  if not TamrielTradeCentre then
    return
  end

  local originalInitializeListingInput = AwesomeGuildStore.class.SellTabWrapper
      .InitializeListingInput
  AwesomeGuildStore.class.SellTabWrapper.InitializeListingInput = function(self,
                                                                           tradingHouseWrapper)
    originalInitializeListingInput(self, tradingHouseWrapper)
    AGSInitializeListingInput(self, tradingHouseWrapper)
  end
end

local function InitTTCInventoryPrice()
  if not GAFE.SavedVars.ttcPrice or not GAFE.SavedVars.ttcPrice.enabled then
    return
  end

  GAFE.InventorySlotHooks.RegisterCallback(SetTTCPrice)
end

--- Initializes AwesomeGuildStore integration if available.
local function InitAGSIntegration()
  if not AwesomeGuildStore then
    return
  end

  InitAGSSetTTCPrice()
end

-------------------------------------------------------------------------------
-- Public Functions
-------------------------------------------------------------------------------

--- Initializes the TTC Price module.
function TTCPrice.Init()
  if not TamrielTradeCentre or not TamrielTradeCentrePrice then
    return
  end

  InitTTCInventoryPrice()
  InitAGSIntegration()
end

-------------------------------------------------------------------------------
-- Module Registration
-------------------------------------------------------------------------------
GAFE.TTCPrice = TTCPrice
