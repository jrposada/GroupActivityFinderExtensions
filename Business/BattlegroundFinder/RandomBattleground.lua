local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER

GAFE.RandomBattleground = {}


function GAFE.RandomBattleground.Init()
    local extender = RandomActivityExtender:New("BattlegroundReward", "ZO_BattlegroundFinder_Keyboard", GAFE.SavedVars.battlegrounds)
    extender:Init()

    local function OnActivityFinderStatusUpdate(_, previousState, nextState)
        local characterId = GetCurrentCharacterId()
        local isRewardAvailable = extender:GetTimeUntilNextReward(characterId) <= 0

        -- GAFE.LogLater("state "..nextState.." | "..(isRewardAvailable and "true" or "false"))
        -- GAFE.LogLater('DETECT IF REWARD HAS BEEN AWARDED')
        if nextState == BATTLEGROUND_STATE_POSTGAME and isRewardAvailable then
            extender.rewardsVars.randomRewards[characterId] = GetTimeStamp()
        end
    end

    EM:RegisterForEvent(extender.name.."Activity_Update", EVENT_BATTLEGROUND_STATE_CHANGED, OnActivityFinderStatusUpdate)
end
