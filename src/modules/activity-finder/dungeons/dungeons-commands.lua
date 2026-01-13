-- =============================================================================
-- Localized Globals
-- =============================================================================
local pairs = pairs

local GetCompletedQuestInfo = GetCompletedQuestInfo
local ZO_GetEffectiveDungeonDifficulty = ZO_GetEffectiveDungeonDifficulty

local GAFE = GroupActivityFinderExtensions
local QueueManager = GAFE.QueueManager
local PledgeTracker = GAFE.PledgeTracker
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

--- Queues dungeons where the associated quest has not been completed.
--- @param verbose string|nil Pass "verbose" to show locked locations in output
local function quests(verbose)
  local function condition(activityData)
    return GetCompletedQuestInfo(activityData.q) == ""
  end

  local activityType = DungeonCommands.GetCurrentDungeonActivityType()
  QueueManager.QueueWhere(activityType, DungeonActivityData, condition,
    verbose)
end

--- Queues dungeons for incomplete pledges currently in the journal.
--- @param verbose string|nil Pass "verbose" to show locked locations in output
local function pledges(verbose)
  local function condition(activityData)
    return PledgeTracker.IsIncompletePledge(activityData.p)
  end

  local activityType = DungeonCommands.GetCurrentDungeonActivityType()
  QueueManager.QueueWhere(activityType, DungeonActivityData, condition,
    verbose)
end

--- Queues a random dungeon at the current effective difficulty.
local function dungeon()
  local activityType = DungeonCommands.GetCurrentDungeonActivityType()
  QueueManager.QueueByActivityType(activityType)
end

local commandsList = {
  { name = "/quests",  func = quests },
  { name = "/pledges", func = pledges },
  { name = "/dungeon", func = dungeon },
}

-- =============================================================================
-- Public Functions
-- =============================================================================

--- Initializes slash commands for dungeon queuing.
function DungeonCommands.Init()
  for _, param in pairs(commandsList) do
    SLASH_COMMANDS[param.name] = param.func
  end
end

--- Gets the current dungeon activity type based on group difficulty.
--- @return number activityType LFG_ACTIVITY_DUNGEON or LFG_ACTIVITY_MASTER_DUNGEON
function DungeonCommands.GetCurrentDungeonActivityType()
  local savedVars = GAFE.SavedVars
  return savedVars.collapse == GAFE_COLLAPSE_MODE.Group and
      (
        ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL
        and LFG_ACTIVITY_DUNGEON
        or LFG_ACTIVITY_MASTER_DUNGEON
      )
      or
      (
        savedVars.collapse == GAFE_COLLAPSE_MODE.Normal
        and LFG_ACTIVITY_DUNGEON
        or LFG_ACTIVITY_MASTER_DUNGEON
      )
end

-- =============================================================================
-- Module Registration
-- =============================================================================
GAFE.DungeonCommands = DungeonCommands
