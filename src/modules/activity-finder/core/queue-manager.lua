-- =============================================================================
-- Localized Globals
-- =============================================================================
local pairs = pairs
local table_insert = table.insert

local ClearActivityFinderSearch = ClearActivityFinderSearch
local GetMaxLevel = GetMaxLevel
local GetString = GetString
local GetUnitChampionPoints = GetUnitChampionPoints
local GetUnitLevel = GetUnitLevel
local IsActiveWorldBattleground = IsActiveWorldBattleground
local IsCurrentlySearchingForGroup = IsCurrentlySearchingForGroup
local IsPlayerInAvAWorld = IsPlayerInAvAWorld
local IsUnitGrouped = IsUnitGrouped
local IsUnitGroupLeader = IsUnitGroupLeader
local StartActivityFinderSearch = StartActivityFinderSearch
local ZO_ACTIVITY_FINDER_ROOT_MANAGER = ZO_ACTIVITY_FINDER_ROOT_MANAGER
local ZO_AlertEvent = ZO_AlertEvent
local ZO_CachedStrFormat = ZO_CachedStrFormat
local ZO_COLLECTIBLE_DATA_MANAGER = ZO_COLLECTIBLE_DATA_MANAGER
local ZO_DoesActivityTypeRequireRoles = ZO_DoesActivityTypeRequireRoles
local ZO_GenerateCommaSeparatedList = ZO_GenerateCommaSeparatedList
local zo_strformat = zo_strformat

local GAFE = GroupActivityFinderExtensions

-- =============================================================================
-- Constants
-- =============================================================================
local PLAYER_UNIT = "player"
local VERBOSE_FLAG = "verbose"

-- =============================================================================
-- Module Declaration
-- =============================================================================
local QueueManager = {}

-- =============================================================================
-- Private Functions
-- =============================================================================

--- Generates a lock reason text based on level or champion point requirements.
--- Adapted from esoui/ingame/lfg/zo_activityfinderroot_manager.lua
--- @param levelMin number Minimum level required
--- @param levelMax number Maximum level allowed
--- @param pointsMin number Minimum champion points required
--- @param pointsMax number Maximum champion points allowed
--- @return string|nil lockReasonText The formatted lock reason, or nil if player meets requirements
local function getLevelOrChampionPointsRequirementText(levelMin, levelMax,
                                                       pointsMin, pointsMax)
  local playerChampionPoints = GetUnitChampionPoints(PLAYER_UNIT)

  if playerChampionPoints > 0 or levelMin == GetMaxLevel() then
    if playerChampionPoints < pointsMin then
      return ZO_CachedStrFormat(
        SI_LFG_LOCK_REASON_PLAYER_MIN_CHAMPION_REQUIREMENT, pointsMin)
    elseif playerChampionPoints > pointsMax then
      return ZO_CachedStrFormat(
        SI_LFG_LOCK_REASON_PLAYER_MAX_CHAMPION_REQUIREMENT, pointsMax)
    end
  else
    local playerLevel = GetUnitLevel(PLAYER_UNIT)

    if playerLevel < levelMin then
      return ZO_CachedStrFormat(SI_LFG_LOCK_REASON_PLAYER_MIN_LEVEL_REQUIREMENT,
        levelMin)
    elseif playerLevel > levelMax then
      return ZO_CachedStrFormat(SI_LFG_LOCK_REASON_PLAYER_MAX_LEVEL_REQUIREMENT,
        levelMax)
    end
  end
end

--- Determines the lock reason text for a location based on collectible requirements.
--- @param location table The location data object
--- @return string lockReasonText The formatted lock reason
local function getCollectibleLockReasonText(location)
  local collectibleId = location:GetFirstLockingCollectible()
  local collectibleData = ZO_COLLECTIBLE_DATA_MANAGER:GetCollectibleDataById(
    collectibleId)

  local lockReasonStringId
  if collectibleData:IsCategoryType(COLLECTIBLE_CATEGORY_TYPE_CHAPTER) then
    lockReasonStringId = SI_LFG_LOCK_REASON_COLLECTIBLE_NOT_UNLOCKED_UPGRADE
  elseif collectibleData:IsPurchasable() then
    lockReasonStringId = SI_LFG_LOCK_REASON_COLLECTIBLE_NOT_UNLOCKED_CROWN_STORE
  else
    lockReasonStringId = SI_LFG_LOCK_REASON_COLLECTIBLE_NOT_UNLOCKED
  end

  return zo_strformat(lockReasonStringId, collectibleData:GetName(),
    collectibleData:GetCategoryData():GetName())
end

-- =============================================================================
-- Public Functions
-- =============================================================================

--- Updates the lock state and reason for a location.
--- Adapted from esoui/ingame/lfg/zo_activityfinderroot_manager.lua -> ActivityFinderRoot_Manager:UpdateLocationData()
--- @param location table The location data object
--- @param activityRequiresRoles boolean Whether the activity requires role selection
--- @param isGroupRelevant boolean Whether the player is in a group
--- @param isLeader boolean Whether the player is the group leader
function QueueManager.UpdateLocationLockState(location,
                                              activityRequiresRoles,
                                              isGroupRelevant, isLeader)
  location:SetLocked(true)
  location:SetCountsForAverageRoleTime(activityRequiresRoles)

  local cooldownText
  local applicableCooldowns = location:GetApplicableCooldownTypes()
  if applicableCooldowns and applicableCooldowns.queueCooldownType then
    cooldownText = ZO_ACTIVITY_FINDER_ROOT_MANAGER:GetLFGCooldownLockText(
      applicableCooldowns.queueCooldownType, CONCISE_COOLDOWN_TEXT)
  end

  if cooldownText then
    location:SetLockReasonText(cooldownText)
  elseif location:IsLockedByPlayerLocation() then
    if IsActiveWorldBattleground() then
      location:SetLockReasonText(SI_LFG_LOCK_REASON_IN_BATTLEGROUND)
    elseif IsPlayerInAvAWorld() then
      location:SetLockReasonText(SI_LFG_LOCK_REASON_IN_AVA)
    end
  elseif location:IsLockedByCollectible() then
    location:SetLockReasonText(getCollectibleLockReasonText(location))
    location:SetCountsForAverageRoleTime(false)
  else
    local groupTooLarge = isGroupRelevant and
        ZO_ACTIVITY_FINDER_ROOT_MANAGER.groupSize > location:GetMaxGroupSize()

    if groupTooLarge then
      location:SetLockReasonText(SI_LFG_LOCK_REASON_GROUP_TOO_LARGE)
    elseif not location:DoesPlayerMeetLevelRequirements() then
      local levelMin, levelMax = location:GetLevelRange()
      local championPointsMin, championPointsMax = location
          :GetChampionPointsRange()
      location:SetLockReasonText(getLevelOrChampionPointsRequirementText(
        levelMin, levelMax, championPointsMin, championPointsMax))
      location:SetCountsForAverageRoleTime(false)
    elseif isGroupRelevant and not location:DoesGroupMeetLevelRequirements() then
      location:SetLockReasonText(
        SI_LFG_LOCK_REASON_GROUP_LOCATION_LEVEL_REQUIREMENTS)
    elseif isGroupRelevant and not isLeader then
      location:SetLockReasonText(SI_LFG_LOCK_REASON_NOT_LEADER)
    else
      location:SetLocked(false)
      location:SetLockReasonText("")
    end
  end
end

--- Finds the first eligible location from a list of activity types.
--- @param activityManager
--- @param onlyActivity
--- @return table|nil location The first eligible location or nil if none found
function QueueManager.FindEligibleLocation(activityManager, onlyActivity)
  local modes = activityManager:GetFilterModeData()
  local activityTypes = modes:GetActivityTypes()

  for _, activityType in ipairs(activityTypes) do
    if not onlyActivity or LibPanicida.Utils.TableContainsValue(activityTypes, onlyActivity) then
      local isActivityLocked = activityManager:GetKeyboardObject()
          :GetLevelLockInfoByActivity(
            activityType)
      if not isActivityLocked then
        local locationsData = ZO_ACTIVITY_FINDER_ROOT_MANAGER:GetLocationsData(
          activityType)
        for _, location in ipairs(locationsData) do
          if modes:IsEntryTypeVisible(location:GetEntryType()) and location:IsActive() and location:DoesPlayerMeetLevelRequirements() then
            return location
          end
        end
      end
    end
  end
  return nil
end

--- Queues a single location and starts the search.
--- @param location table The location to queue
--- @param activityName string Display name for the activity type
function QueueManager.QueueAndStart(location, activityName)
  ZO_ACTIVITY_FINDER_ROOT_MANAGER:SetLocationSelected(location, true)
  location:AddActivitySearchEntry()

  local result = StartActivityFinderSearch()
  if result ~= ACTIVITY_QUEUE_RESULT_SUCCESS then
    ZO_AlertEvent(EVENT_ACTIVITY_QUEUE_RESULT, result)
  else
    LibPanicida.Debug.LogLater(zo_strformat(GAFE.Loc("QueueForActivity"),
      activityName,
      GetString(SI_GROUPFINDERCATEGORY_SINGLESELECTDEFAULT0)
    ))
  end
end

--- Queues locations matching a condition and starts the search.
--- @param activityType number The LFG activity type
--- @param activityData table Activity data lookup table keyed by location ID
--- @param condition function Predicate function (activityData) -> boolean
--- @param verbose string|nil Pass "verbose" to show locked locations in output
function QueueManager.QueueWhere(activityType, activityData, condition,
                                 verbose)
  if IsCurrentlySearchingForGroup() then
    return
  end

  ClearActivityFinderSearch()

  local lockedLocations = {}
  local queuedLocations = {}
  local isGroupRelevant = IsUnitGrouped(PLAYER_UNIT)
  local isLeader = IsUnitGroupLeader(PLAYER_UNIT)
  local activityRequiresRoles = ZO_DoesActivityTypeRequireRoles(activityType)
  local sortedLocationsData = ZO_ACTIVITY_FINDER_ROOT_MANAGER
      .specificLocationsLookupData[activityType]

  for _, location in pairs(sortedLocationsData) do
    QueueManager.UpdateLocationLockState(location, activityRequiresRoles,
      isGroupRelevant, isLeader)

    if location:IsLocked() then
      table_insert(lockedLocations,
        location.rawName .. ": " .. location.lockReasonText)
    else
      local data = activityData[location.id]
      if data and condition(data) then
        ZO_ACTIVITY_FINDER_ROOT_MANAGER:SetLocationSelected(location, true)
        location:AddActivitySearchEntry()
        table_insert(queuedLocations, location.rawName)
      end
    end
  end

  local result = StartActivityFinderSearch()
  if result ~= ACTIVITY_QUEUE_RESULT_SUCCESS then
    ZO_AlertEvent(EVENT_ACTIVITY_QUEUE_RESULT, result)
  else
    LibPanicida.Debug.LogLater(GAFE.Loc("Debug_QueuedList") ..
      ZO_GenerateCommaSeparatedList(queuedLocations))

    if verbose == VERBOSE_FLAG then
      LibPanicida.Debug.LogLater(GAFE.Loc("Debug_NotQueuedList") ..
        ZO_GenerateCommaSeparatedList(lockedLocations))
    end
  end
end

--- Checks if the player is currently searching for a group.
--- @return boolean isSearching True if currently searching
function QueueManager.IsSearching()
  return IsCurrentlySearchingForGroup()
end

--- Clears the current activity finder search.
function QueueManager.ClearSearch()
  ClearActivityFinderSearch()
end

-- Module Registration
GAFE.QueueManager = QueueManager
