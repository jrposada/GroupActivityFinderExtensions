local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER

GAFE.RandomDungeon = {}


function GAFE.RandomDungeon.Init()
    local extender = RandomActivityExtender:New("DungeonReward", "ZO_DungeonFinder_Keyboard", GAFE.SavedVars.dungeons)
    extender:Init()

    local function OnActivityFinderStatusUpdate(_, status)
        -- Check 1 second later so IsActivityEligibleForDailyReward is ready.
        zo_callLater(function()
            local characterId = GetCurrentCharacterId()
            local isRewardAvailable = RandomActivityExtender_GetTimeUntilNextReward(characterId, extender.rewardsVars) <= 0
            -- There are several dungeon activities but so far they all share the reward.
            local isRewardAvailableByZos = IsActivityEligibleForDailyReward(LFG_ACTIVITY_DUNGEON)

            if status == ACTIVITY_FINDER_STATUS_COMPLETE and isRewardAvailable and not isRewardAvailableByZos then
                extender.rewardsVars.randomRewards[characterId] = GetTimeStamp()
            end
        end, 1000)
    end

    EM:RegisterForEvent(extender.name.."Activity_Update", EVENT_ACTIVITY_FINDER_STATUS_UPDATE, OnActivityFinderStatusUpdate)
end
