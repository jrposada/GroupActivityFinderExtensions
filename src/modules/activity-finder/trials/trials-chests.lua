local GAFE = GroupActivityFinderExtensions

local function UpdateChestTimes(_, isCompleted, _, _, _, _, questId)
    local trialQuest = {
        [GAFE_TRIALS_ACTIVITY_DATA[GAFE_ACTIVITY_ID.NormalAetherianArchive].q] = true,
        [GAFE_TRIALS_ACTIVITY_DATA[GAFE_ACTIVITY_ID.NormalHelRaCitadel].q] = true,
        [GAFE_TRIALS_ACTIVITY_DATA[GAFE_ACTIVITY_ID.NormalSanctumOphidia].q] = true,
        [GAFE_TRIALS_ACTIVITY_DATA[GAFE_ACTIVITY_ID.NormalMawOfLorkhaj].q] = true,
        [GAFE_TRIALS_ACTIVITY_DATA[GAFE_ACTIVITY_ID.NormalHallsOfFabrication].q] = true,
        [GAFE_TRIALS_ACTIVITY_DATA[GAFE_ACTIVITY_ID.NormalAsylumSanctorium].q] = true,
        [GAFE_TRIALS_ACTIVITY_DATA[GAFE_ACTIVITY_ID.NormalCloudrest].q] = true,
        [GAFE_TRIALS_ACTIVITY_DATA[GAFE_ACTIVITY_ID.NormalSunspire].q] = true,
        [GAFE_TRIALS_ACTIVITY_DATA[GAFE_ACTIVITY_ID.NormalKynesAegis].q] = true,
        [GAFE_TRIALS_ACTIVITY_DATA[GAFE_ACTIVITY_ID.NormalDreadsailReef].q] = true,
    }

    local canGetChest = GAFE_TRIALS_CHESTS.GetTimeUntilNextChest(GetCurrentCharacterId(), questId) <= 0
    if trialQuest[questId] and isCompleted and canGetChest then
        GAFE_TRIALS_CHESTS.ResetChest(questId)
    end
end

GAFE_TRIALS_CHESTS = {}

function GAFE_TRIALS_CHESTS.Init()
    -- InitSavedVars
    local chestsVars = GAFE.SavedVars.trials.chests

    local characters = {}
    local numCharacters = GetNumCharacters()
    for i = 1, numCharacters do
        local _, _, _, _, _, _, id, _ = GetCharacterInfo(i)

        if chestsVars[id] == nil then
            chestsVars[id] = {}
        end

        characters[id] = true
    end

    -- Remove extra id
    for id, _ in pairs(chestsVars) do
        if (not characters[id]) then
            chestsVars[id] = nil
        end
    end

    EVENT_MANAGER:RegisterForEvent(GAFE.name .. "_QuestRemoved", EVENT_QUEST_REMOVED, UpdateChestTimes)
end

function GAFE_TRIALS_CHESTS.GetTimeUntilNextChest(characterId, questId)
    local result = 0

    local completedTimeStamp = GAFE.SavedVars.trials.chests[characterId][questId]
    if completedTimeStamp then
        result = GetDiffBetweenTimeStamps(completedTimeStamp + 604800, GetTimeStamp()) -- 604800 = 1 week
    end

    return result >= 0 and result or 0
end

function GAFE_TRIALS_CHESTS.ResetChest(questId)
    local characterId = GetCurrentCharacterId()
    local completedTimeStamp = GAFE.SavedVars.trials.chests[characterId]
    completedTimeStamp[questId] = GetTimeStamp()
end
