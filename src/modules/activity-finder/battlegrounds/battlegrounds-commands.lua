-- =============================================================================
-- Localized Globals
-- =============================================================================
local pairs = pairs
local GetString = GetString

local GAFE = GroupActivityFinderExtensions

-- =============================================================================
-- Constants
-- =============================================================================
local BATTLEGROUND_ACTIVITY_TYPES = {
  LFG_ACTIVITY_BATTLE_GROUND_CHAMPION,
  LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION,
  LFG_ACTIVITY_BATTLE_GROUND_LOW_LEVEL,
}

-- =============================================================================
-- Module Declaration
-- =============================================================================
local BattlegroundCommands = {}

-- =============================================================================
-- Private Functions
-- =============================================================================

--- Queues a random battleground based on player eligibility.
local function battleground()
  if GAFE_QueueManager.IsSearching() then
    return
  end

  GAFE_QueueManager.ClearSearch()

  local location = GAFE_QueueManager.FindEligibleLocation(
    BATTLEGROUND_ACTIVITY_TYPES)

  if not location then
    LibPanicida.Debug.LogLater("No eligible battleground found")
    return
  end

  GAFE_QueueManager.QueueAndStart(location, GetString(SI_LFGACTIVITY4))
end

local commandsList = {
  { name = "/bg", func = battleground },
}

-- =============================================================================
-- Public Functions
-- =============================================================================

--- Initializes slash commands for battleground queuing.
function BattlegroundCommands.Init()
  for _, param in pairs(commandsList) do
    SLASH_COMMANDS[param.name] = param.func
  end
end

-- =============================================================================
-- Module Registration
-- =============================================================================
GAFE.BattlegroundCommands = BattlegroundCommands
