-- ============================================================================
-- Localized Globals
-- ============================================================================
local EVENT_MANAGER = EVENT_MANAGER
local GetTimeStamp = GetTimeStamp
local IsActivityEligibleForDailyReward = IsActivityEligibleForDailyReward
local zo_callLater = zo_callLater

-- ============================================================================
-- Constants
-- ============================================================================
local BATTLEGROUND_REWARD_CHECK_DELAY_MS = 1000
local GAFE = GroupActivityFinderExtensions

-- ============================================================================
-- Module Declaration
-- ============================================================================
local BattlegroundsExtensions = {}

-- ============================================================================
-- Private Functions
-- ============================================================================
local extender = GAFE_ActivityFinderExtender:New()

--- Handles battleground state changes to track daily reward consumption.
--- Delays check by 1 second to allow IsActivityEligibleForDailyReward to update.
--- @param _eventCode number The event code (unused)
--- @param _previousState number The previous battleground state (unused)
--- @param nextState number The new battleground state
local function onActivityFinderStatusUpdate(_eventCode, _previousState, nextState)
  zo_callLater(function()
    local isRewardAvailableByTimer = extender.GetTimeUntilNextReward(
      extender.characterId, extender.rewardsVars) <= 0
    -- All battleground activities share the same daily reward
    local isRewardAvailableByZos = IsActivityEligibleForDailyReward(
      LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION)

    if nextState == BATTLEGROUND_STATE_FINISHED and isRewardAvailableByTimer and not isRewardAvailableByZos then
      extender.rewardsVars.randomRewards[extender.characterId] = GetTimeStamp()
    end
  end, BATTLEGROUND_REWARD_CHECK_DELAY_MS)
end

-- ============================================================================
-- Public Functions
-- ============================================================================

--- Initializes the battlegrounds extensions module.
--- Sets up the extender and registers for battleground state change events.
function BattlegroundsExtensions.Init()
  extender:Initialize({
    rewardsVars = GAFE.SavedVars.battlegrounds,
    root = "ZO_Battleground",
  })

  EVENT_MANAGER:RegisterForEvent(
    extender.root .. "Activity_Update",
    EVENT_BATTLEGROUND_STATE_CHANGED,
    onActivityFinderStatusUpdate
  )
end

-- ============================================================================
-- Module Registration
-- ============================================================================
GAFE.BattlegroundsExtensions = BattlegroundsExtensions
