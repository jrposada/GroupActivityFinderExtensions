-------------------------------------------------------------------------------
-- Armory Icon Module
-- Displays armory build icons on inventory items that are part of armory builds.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Localized Globals
-------------------------------------------------------------------------------
local GetItemArmoryBuildList = GetItemArmoryBuildList
local GetNumArmoryBuilds = GetNumArmoryBuilds
local GetArmoryBuildIconIndex = GetArmoryBuildIconIndex
local GetArmoryBuildName = GetArmoryBuildName
local IsItemInArmory = IsItemInArmory
local ipairs = ipairs
local string_format = string.format
local table_insert = table.insert

local GAFE = GroupActivityFinderExtensions

-------------------------------------------------------------------------------
-- Constants
-------------------------------------------------------------------------------
local ARMORY_ICON_SIZE = 32
local ARMORY_ICON_OFFSET_X = -37
local TOOLTIP_ICON_SIZE = 16
local TOOLTIP_ICON_FORMAT = "|t%d:%d:%s|t %s"

-------------------------------------------------------------------------------
-- Module Declaration
-------------------------------------------------------------------------------
local ArmoryIcon = {}

-------------------------------------------------------------------------------
-- Private State
-------------------------------------------------------------------------------
local armoryBuildIconIndexByBuildName = {}

-------------------------------------------------------------------------------
-- Private Functions
-------------------------------------------------------------------------------

--- Rebuilds the mapping of build names to icon indices.
--- Should be called when armory builds change.
local function RebuildBuildNameMapping()
  armoryBuildIconIndexByBuildName = {}

  local numBuilds = GetNumUnlockedArmoryBuilds()
  for buildIndex = 1, numBuilds do
    local buildName = GetArmoryBuildName(buildIndex)
    if buildName and buildName ~= "" then
      local iconIndex = GetArmoryBuildIconIndex(buildIndex)
      armoryBuildIconIndexByBuildName[buildName] = iconIndex
    end
  end
end

--- Sets the armory icon on items that are part of armory builds.
--- @param control any The inventory row control
--- @param slot table The slot data containing bag and slot info
local function SetArmoryInfo(control, slot)
  if IsItemInArmory(slot.bagId, slot.slotIndex) then
    local armoryBuildList = { GetItemArmoryBuildList(slot.bagId, slot.slotIndex) }

    if #armoryBuildList == 0 then
      return
    end

    local traitInfoControl = control:GetNamedChild("TraitInfo")
    if not traitInfoControl then
      return
    end

    local armoryControl = LibPanicida.Controls.MultiIcon(
      control:GetName() .. "GAFE_Armory",
      control,
      { ARMORY_ICON_SIZE, ARMORY_ICON_SIZE },
      { RIGHT, traitInfoControl, RIGHT, ARMORY_ICON_OFFSET_X, 0 }
    )

    if armoryControl == nil then
      return
    end

    armoryControl:ClearIcons()

    local tooltipLines = { GAFE.Loc("ArmoryIcon_Tooltip") }
    for _, buildName in ipairs(armoryBuildList) do
      local buildIconIndex = armoryBuildIconIndexByBuildName[buildName]
      if buildIconIndex then
        local buildIcon = string_format(ZO_ARMORY_BUILD_ICON_TEXTURE_FORMATTER,
          buildIconIndex)
        local tooltipLine = string_format(TOOLTIP_ICON_FORMAT,
          TOOLTIP_ICON_SIZE, TOOLTIP_ICON_SIZE, buildIcon, buildName)
        table_insert(tooltipLines, tooltipLine)
        armoryControl:AddIcon(buildIcon)
      end
    end

    if #tooltipLines > 1 then
      LibPanicida.Controls.SetTooltip(
        armoryControl,
        tooltipLines
      )
    end

    armoryControl:SetDrawTier(DT_HIGH)
    armoryControl:Show()
  else
    local armoryControl = control:GetNamedChild("GAFE_Armory")
    if armoryControl then
      armoryControl:ClearIcons()
    end
  end
end

-------------------------------------------------------------------------------
-- Public Functions
-------------------------------------------------------------------------------

--- Initializes the Armory Icon module.
function ArmoryIcon.Init()
  RebuildBuildNameMapping()
  GAFE.InventorySlotHooks.RegisterCallback(SetArmoryInfo)
end

--- Called when an armory build is updated.
--- Rebuilds the name-to-icon mapping.
function ArmoryIcon.OnBuildUpdated()
  RebuildBuildNameMapping()
end

-------------------------------------------------------------------------------
-- Module Registration
-------------------------------------------------------------------------------
GAFE.ArmoryIcon = ArmoryIcon
