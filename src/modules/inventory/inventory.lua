local GAFE = GroupActivityFinderExtensions

GAFE_INVENTORY = {}

local armoryLabel
local armoryIcon

local function GetCharacterId()
  return GetCurrentCharacterId()
end

local function GetSavedBuildIndex()
  local characterId = GetCharacterId()
  return GAFE.SavedVars.armory.currentBuildIndex[characterId]
end

local function SetSavedBuildIndex(buildIndex)
  local characterId = GetCharacterId()
  GAFE.SavedVars.armory.currentBuildIndex[characterId] = buildIndex
end

local function GetArmoryBuildIconTexture(buildIndex)
  local iconIndex = GetArmoryBuildIconIndex(buildIndex)
  if iconIndex and iconIndex > 0 then
    return string.format("EsoUI/Art/Armory/BuildIcons/buildIcon_%d.dds",
      iconIndex)
  end
  return nil
end

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

  local iconSize = 24

  -- Create the icon texture (positioned right of Equipped label)
  armoryIcon = LibPanicida.Controls.Texture(
    "GAFE_ArmoryBuildIcon",
    ZO_Character,
    { iconSize, iconSize },
    { LEFT, equippedLabel, RIGHT, 10, 0 },
    nil
  )
  armoryIcon:SetHidden(true)

  -- Create the label (positioned right of the icon)
  armoryLabel = LibPanicida.Controls.Label(
    "GAFE_ArmoryBuildLabel",
    ZO_Character,
    { 120, iconSize },
    { LEFT, armoryIcon, RIGHT, 4, 0 },
    "ZoFontGameShadow",
    nil,
    { 0, 1 }
  )
  armoryLabel:SetHidden(true)
  armoryLabel:SetColor(1, 1, 1, 0.8)

  UpdateArmoryDisplay()
end

local function OnShown()
  CreateArmoryDisplay()
end

local function OnArmoryBuildRestored(eventCode, result, buildIndex)
  if result == ARMORY_BUILD_RESTORE_RESULT_SUCCESS then
    SetSavedBuildIndex(buildIndex)
    UpdateArmoryDisplay()
  end
end

local function OnArmoryBuildSaved(eventCode, result, buildIndex)
  if result == ARMORY_BUILD_SAVE_RESULT_SUCCESS then
    SetSavedBuildIndex(buildIndex)
    UpdateArmoryDisplay()
  end
end

local function OnArmoryBuildUpdated(eventCode, buildIndex)
  SetSavedBuildIndex(buildIndex)
  UpdateArmoryDisplay()
end

function GAFE_INVENTORY.Init()
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

  EVENT_MANAGER:RegisterForEvent(
    GAFE.name .. "_Inventory_ArmorySave",
    EVENT_ARMORY_BUILD_UPDATED,
    OnArmoryBuildUpdated
  )
end
