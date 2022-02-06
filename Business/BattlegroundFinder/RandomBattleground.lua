local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER

GAFE.RandomBattleground = {}


function GAFE.RandomBattleground.Init()
    local extender = RandomActivityExtender:New("BattlegroundReward", "ZO_BattlegroundFinder_Keyboard", GAFE.SavedVars.battlegrounds)
    extender:Init()

    local function OnActivityFinderStatusUpdate(_, previousState, nextState)
        if nextState == BATTLEGROUND_STATE_POSTGAME then
            local characterId = GetCurrentCharacterId()
            extender.rewardsVars.randomRewards[characterId] = GetTimeStamp()
        end
    end

    EM:RegisterForEvent(extender.name.."Activity_Update", EVENT_BATTLEGROUND_STATE_CHANGED, OnActivityFinderStatusUpdate)
end
