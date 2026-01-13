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
  if QueueManager.IsSearching() then
    return
  end

  QueueManager.ClearSearch()

  local location = QueueManager.FindEligibleLocation(
    BATTLEGROUND_FINDER_MANAGER)

  if not location then
    LibPanicida.Debug.LogLater("No eligible battleground found")
    return
  end

  QueueManager.QueueAndStart(location,
    location:GetNameKeyboard())
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
