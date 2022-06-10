local GAFE = GroupActivityFinderExtensions

GAFE_BATTLEGROUNDS_EXTENSIONS = {}

local extender = GAFE_ActivityFinderExtender:New()


function GAFE_BATTLEGROUNDS_EXTENSIONS.Init()
    local function OnActivityFinderStatusUpdate(_, previousState, nextState)
        -- Check 1 second later so IsActivityEligibleForDailyReward is ready.
        zo_callLater(function()
            local isRewardAvailableByTimer = extender.GetTimeUntilNextReward(extender.characterId, extender.rewardsVars) <= 0
            -- There are several battleground activities but so far they all share the reward.
            local isRewardAvailableByZos = IsActivityEligibleForDailyReward(LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION)

            if nextState == BATTLEGROUND_STATE_POSTGAME and isRewardAvailableByTimer and not isRewardAvailableByZos then
                extender.rewardsVars.randomRewards[extender.characterId] = GetTimeStamp()
            end
        end, 1000)
    end

    extender:Initialize("ZO_Battleground", nil, nil, nil, GAFE.SavedVars.battlegrounds, nil, nil)
    EVENT_MANAGER:RegisterForEvent(extender.root.."Activity_Update", EVENT_BATTLEGROUND_STATE_CHANGED, OnActivityFinderStatusUpdate)
end
