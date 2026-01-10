-------------------------------------------------------------------------------
-- Inventory Module
-- Displays the current armory build on the character panel.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Localized Globals
-------------------------------------------------------------------------------
local EVENT_MANAGER = EVENT_MANAGER
local GetCurrentCharacterId = GetCurrentCharacterId
local GetArmoryBuildIconIndex = GetArmoryBuildIconIndex
local GetArmoryBuildName = GetArmoryBuildName
local ZO_PreHookHandler = ZO_PreHookHandler
local string_format = string.format

local GAFE = GroupActivityFinderExtensions

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local ARMORY_ICON_SIZE = 24
local ARMORY_LABEL_WIDTH = 120
local ARMORY_LABEL_ALPHA = 0.8
local ARMORY_ICON_PATH_FORMAT = "EsoUI/Art/Armory/BuildIcons/buildIcon_%d.dds"

-------------------------------------------------------------------------------
-- Module Declaration
-------------------------------------------------------------------------------
local Inventory = {}

-------------------------------------------------------------------------------
-- Private State
-------------------------------------------------------------------------------
local armoryLabel
local armoryIcon

-------------------------------------------------------------------------------
-- Private Functions
-------------------------------------------------------------------------------

--- Gets the current character's unique identifier.
--- @return string characterId The current character's ID
local function GetCharacterId()
  return GetCurrentCharacterId()
end

--- Retrieves the saved armory build index for the current character.
--- @return number|nil buildIndex The saved build index, or nil if none saved
local function GetSavedBuildIndex()
  local characterId = GetCharacterId()
  return GAFE.SavedVars.armory.currentBuildIndex[characterId]
end

--- Saves the armory build index for the current character.
--- @param buildIndex number The build index to save
local function SetSavedBuildIndex(buildIndex)
  local characterId = GetCharacterId()
  GAFE.SavedVars.armory.currentBuildIndex[characterId] = buildIndex
end

--- Gets the texture path for an armory build icon.
--- @param buildIndex number The armory build index
--- @return string|nil iconPath The icon texture path, or nil if no valid icon
local function GetArmoryBuildIconTexture(buildIndex)
  local iconIndex = GetArmoryBuildIconIndex(buildIndex)
  if iconIndex and iconIndex > 0 then
    return string_format(ARMORY_ICON_PATH_FORMAT, iconIndex)
  end
  return nil
end

--- Gets the current armory build information for display.
--- @return string|nil buildName The build name, or nil if no build
--- @return string|nil iconTexture The icon texture path, or nil if no icon
--- @return number|nil buildIndex The build index, or nil if no build
local function GetCurrentArmoryBuildInfo()
  local buildIndex = GetSavedBuildIndex()

  if buildIndex and buildIndex > 0 then
    local buildName = GetArmoryBuildName(buildIndex)
    if buildName and buildName ~= "" then
      local iconTexture = GetArmoryBuildIconTexture(buildIndex)
      return buildName, iconTexture, buildIndex
    end
  end

  return nil, nil, nil
end

--- Updates the armory display with current build information.
local function UpdateArmoryDisplay()
  local buildName, iconPath, buildIndex = GetCurrentArmoryBuildInfo()

  if buildName and armoryLabel and armoryIcon then
    armoryLabel:SetText(buildName)
    armoryLabel:SetHidden(false)

    if iconPath then
      armoryIcon:SetTexture(iconPath)
      armoryIcon:SetHidden(false)
    else
      armoryIcon:SetHidden(true)
    end
  elseif armoryLabel then
    armoryLabel:SetHidden(true)
    armoryIcon:SetHidden(true)
  end
end

--- Creates the armory display UI elements on the character panel.
local function CreateArmoryDisplay()
  if armoryLabel then
    UpdateArmoryDisplay()
    return
  end

  -- Find the "Equipped" title label in the Character panel
  local equippedLabel = ZO_CharacterHeaderSectionTitle
  if not equippedLabel then
    return
  end

  -- Create the icon texture (positioned right of Equipped label)
  armoryIcon = LibPanicida.Controls.Texture(
    "GAFE_ArmoryBuildIcon",
    ZO_Character,
    { ARMORY_ICON_SIZE, ARMORY_ICON_SIZE },
    { LEFT, equippedLabel, RIGHT, 10, 0 },
    nil
  )
  armoryIcon:SetHidden(true)

  -- Create the label (positioned right of the icon)
  armoryLabel = LibPanicida.Controls.Label(
    "GAFE_ArmoryBuildLabel",
    ZO_Character,
    { ARMORY_LABEL_WIDTH, ARMORY_ICON_SIZE },
    { LEFT, armoryIcon, RIGHT, 4, 0 },
    "ZoFontGameShadow",
    nil,
    { 0, 1 }
  )
  armoryLabel:SetHidden(true)
  armoryLabel:SetColor(1, 1, 1, ARMORY_LABEL_ALPHA)

  UpdateArmoryDisplay()
end

--- Handler for when the character panel is shown.
local function OnShown()
  CreateArmoryDisplay()
end

--- Handler for armory build restore events.
--- @param eventCode number The event code
--- @param result number The restore result code
--- @param buildIndex number The build index that was restored
local function OnArmoryBuildRestored(eventCode, result, buildIndex)
  if result == ARMORY_BUILD_RESTORE_RESULT_SUCCESS then
    SetSavedBuildIndex(buildIndex)
    UpdateArmoryDisplay()
  end
end

--- Handler for armory build save events.
--- @param eventCode number The event code
--- @param result number The save result code
--- @param buildIndex number The build index that was saved
local function OnArmoryBuildSaved(eventCode, result, buildIndex)
  if result == ARMORY_BUILD_SAVE_RESULT_SUCCESS then
    SetSavedBuildIndex(buildIndex)
    UpdateArmoryDisplay()
  end
end

--- Handler for armory build update events.
--- @param eventCode number The event code
--- @param buildIndex number The build index that was updated
local function OnArmoryBuildUpdated(eventCode, buildIndex)
  SetSavedBuildIndex(buildIndex)
  UpdateArmoryDisplay()
end

-------------------------------------------------------------------------------
-- Public Functions
-------------------------------------------------------------------------------

--- Initializes the inventory module.
--- Sets up event handlers and hooks for armory build tracking.
function Inventory.Init()
  -- Hook into Character panel show
  ZO_PreHookHandler(ZO_Character, 'OnEffectivelyShown', OnShown)

  -- Listen for armory build restore events
  EVENT_MANAGER:RegisterForEvent(
    GAFE.name .. "_Inventory_ArmoryRestore",
    EVENT_ARMORY_BUILD_RESTORE_RESPONSE,
    OnArmoryBuildRestored
  )

  -- Listen for armory build save events
  EVENT_MANAGER:RegisterForEvent(
    GAFE.name .. "_Inventory_ArmorySave",
    EVENT_ARMORY_BUILD_SAVE_RESPONSE,
    OnArmoryBuildSaved
  )

  -- Listen for armory build update events
  EVENT_MANAGER:RegisterForEvent(
    GAFE.name .. "_Inventory_ArmoryUpdate",
    EVENT_ARMORY_BUILD_UPDATED,
    OnArmoryBuildUpdated
  )
end

-------------------------------------------------------------------------------
-- Module Registration
-------------------------------------------------------------------------------
GAFE.Inventory = Inventory
