-- =============================================================================
-- Localized Globals
-- =============================================================================
local GetTimeStamp = GetTimeStamp
local IsActivityEligibleForDailyReward = IsActivityEligibleForDailyReward
local zo_callLater = zo_callLater

local GAFE = GroupActivityFinderExtensions

-- =============================================================================
-- Constants
-- =============================================================================
local DEFAULT_DELAY_MS = 1000

-- =============================================================================
-- Module Declaration
-- =============================================================================
local RewardTracker = {}

-- =============================================================================
-- Public Functions
-- =============================================================================

function RewardTracker.CreateCompletionHandler(params)
  local activityType = params.activityType
  local completionState = params.completionState
  local extender = params.extender
  local delayMs = params.delayMs or DEFAULT_DELAY_MS

  return function(_eventCode, _previousState, nextState)
    zo_callLater(function()
      local isRewardAvailableByTimer = extender.GetTimeUntilNextReward(
        extender.characterId, extender.rewardsVars) <= 0
      local isRewardAvailableByZos = IsActivityEligibleForDailyReward(
        activityType)

      if nextState == completionState and isRewardAvailableByTimer and not isRewardAvailableByZos then
        extender.rewardsVars.randomRewards[extender.characterId] = GetTimeStamp()
      end
    end, delayMs)
  end
end

-- Module Registration
GAFE.RewardTracker = RewardTracker
