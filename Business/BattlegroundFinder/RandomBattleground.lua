local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER

GAFE.RandomBattleground = {}


function GAFE.RandomBattleground.Init()
    local extender = RandomActivityExtender:New("BattlegroundReward", "ZO_BattlegroundFinder_Keyboard", GAFE.SavedVars.battlegrounds)
    extender:Init()

    local function OnActivityFinderStatusUpdate(_, previousState, nextState)
        -- Check 1 second later so IsActivityEligibleForDailyReward is ready.
        zo_callLater(function()
            local characterId = GetCurrentCharacterId()
            local isRewardAvailableByTimer = RandomActivityExtender_GetTimeUntilNextReward(characterId, extender.rewardsVars) <= 0
            -- There are several battleground activities but so far they all share the reward.
            local isRewardAvailableByZos = IsActivityEligibleForDailyReward(LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION)
            if nextState == BATTLEGROUND_STATE_POSTGAME and isRewardAvailableByTimer and not isRewardAvailableByZos then
                extender.rewardsVars.randomRewards[characterId] = GetTimeStamp()
            end
        end, 1000)
    end

    EM:RegisterForEvent(extender.name.."Activity_Update", EVENT_BATTLEGROUND_STATE_CHANGED, OnActivityFinderStatusUpdate)
end
