local GAFE = GroupActivityFinderExtensions

local function battleground()
    -- local numActivities = GetNumActivitiesByType(activityType)

    -- GetActivityIdByTypeAndIndex()
    -- AddActivityFinderSetSearchEntry
end

local commandsList = {
    { name = "/bg", func = battleground },
}

GAFE_BATTLEGROUND_COMMANDS = {}

function GAFE_BATTLEGROUND_COMMANDS.Init()
    for _, param in pairs(commandsList) do
        SLASH_COMMANDS[param.name] = param.func
    end
end
