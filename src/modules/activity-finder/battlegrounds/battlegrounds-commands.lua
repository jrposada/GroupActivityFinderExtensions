-- =============================================================================
-- Localized Globals
-- =============================================================================
local pairs = pairs
local GetString = GetString
local BATTLEGROUND_FINDER_MANAGER = BATTLEGROUND_FINDER_MANAGER

local GAFE = GroupActivityFinderExtensions
local QueueManager = GAFE.QueueManager


-- =============================================================================
-- Module Declaration
-- =============================================================================
local BattlegroundCommands = {}

-- =============================================================================
-- Private Functions
-- =============================================================================

--- Queues a random battleground based on player eligibility.
local function battleground()
  local activityType = nil
  if GetUnitLevel("player") ~= 50 then
    activityType = LFG_ACTIVITY_BATTLE_GROUND_LOW_LEVEL
  else
    activityType = LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION
  end
  QueueManager.QueueByActivityType(activityType)
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
