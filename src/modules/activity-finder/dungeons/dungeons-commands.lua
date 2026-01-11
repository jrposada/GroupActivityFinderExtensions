-- =============================================================================
-- Localized Globals
-- =============================================================================
local pairs = pairs

local GetCompletedQuestInfo = GetCompletedQuestInfo
local GetString = GetString
local ZO_GetEffectiveDungeonDifficulty = ZO_GetEffectiveDungeonDifficulty

local GAFE = GroupActivityFinderExtensions
local QueueManager = GAFE.QueueManager
local DungeonActivityData = GAFE_DUNGEONS_ACTIVITY_DATA

-- =============================================================================
-- Constants
-- =============================================================================

-- =============================================================================
-- Module Declaration
-- =============================================================================
local DungeonCommands = {}

-- =============================================================================
-- Private Functions
-- =============================================================================

--- Gets the current dungeon activity type based on group difficulty.
--- @return number activityType LFG_ACTIVITY_DUNGEON or LFG_ACTIVITY_MASTER_DUNGEON
local function getCurrentDungeonActivityType()
  return ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL
      and LFG_ACTIVITY_DUNGEON
      or LFG_ACTIVITY_MASTER_DUNGEON
end

--- Queues dungeons where the associated quest has not been completed.
--- @param verbose string|nil Pass "verbose" to show locked locations in output
local function quests(verbose)
  local function condition(activityData)
    return GetCompletedQuestInfo(activityData.q) == ""
  end

  local activityType = getCurrentDungeonActivityType()
  QueueManager.QueueWhere(activityType, DungeonActivityData, condition,
    verbose)
end

--- Queues dungeons for incomplete pledges currently in the journal.
--- @param verbose string|nil Pass "verbose" to show locked locations in output
local function pledges(verbose)
  local function condition(activityData)
    return GAFE_PledgeTracker.IsIncompletePledge(activityData.p)
  end

  local activityType = getCurrentDungeonActivityType()
  QueueManager.QueueWhere(activityType, DungeonActivityData, condition,
    verbose)
end

--- Queues a random dungeon at the current effective difficulty.
local function dungeon()
  if QueueManager.IsSearching() then
    return
  end

  QueueManager.ClearSearch()

  local activityType = getCurrentDungeonActivityType()
  local location = QueueManager.FindEligibleLocation({ activityType })

  if not location then
    LibPanicida.Debug.LogLater("No eligible random dungeon found")
    return
  end

  local activityName = activityType == LFG_ACTIVITY_DUNGEON
      and GetString(SI_DUNGEONDIFFICULTY1)
      or GetString(SI_DUNGEONDIFFICULTY2)

  QueueManager.QueueAndStart(location, activityName)
end

local commandsList = {
  { name = "/quests",  func = quests },
  { name = "/pledges", func = pledges },
  { name = "/dungeon", func = dungeon },
}

--- Displays help information for available slash commands.
local function help()
  for _, param in pairs(commandsList) do
    LibPanicida.Debug.LogLater(param)
  end
end

-- =============================================================================
-- Public Functions
-- =============================================================================

--- Initializes slash commands for dungeon queuing.
function DungeonCommands.Init()
  SLASH_COMMANDS["/gafe"] = help

  for _, param in pairs(commandsList) do
    SLASH_COMMANDS[param.name] = param.func
  end
end

-- =============================================================================
-- Module Registration
-- =============================================================================
GAFE.DungeonCommands = DungeonCommands
