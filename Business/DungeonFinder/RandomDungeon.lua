local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER

GAFE.RandomDungeon = {}


function GAFE.RandomDungeon.Init()
    local extender = RandomActivityExtender:New("DungeonReward", "ZO_DungeonFinder_Keyboard", GAFE.SavedVars.dungeons)
    extender:Init()

    local function OnActivityFinderStatusUpdate(_, status)
        local characterId = GetCurrentCharacterId()
        local isRewardAvailable = RandomActivityExtender_GetTimeUntilNextReward(characterId, extender.rewardsVars) <= 0

        if status == ACTIVITY_FINDER_STATUS_COMPLETE and isRewardAvailable then
            extender.rewardsVars.randomRewards[characterId] = GetTimeStamp()
        end
    end

    EM:RegisterForEvent(extender.name.."Activity_Update", EVENT_ACTIVITY_FINDER_STATUS_UPDATE, OnActivityFinderStatusUpdate)
end
