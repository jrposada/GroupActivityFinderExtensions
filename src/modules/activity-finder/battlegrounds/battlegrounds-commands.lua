local GAFE = GroupActivityFinderExtensions
local ZO_AFRM = ZO_ACTIVITY_FINDER_ROOT_MANAGER

local function battleground()
    if IsCurrentlySearchingForGroup() then
        return
    end

    ClearActivityFinderSearch()

    local battlegroundActivityTypes = {
        LFG_ACTIVITY_BATTLE_GROUND_CHAMPION,
        LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION,
        LFG_ACTIVITY_BATTLE_GROUND_LOW_LEVEL,
    }

    local location = nil
    for _, activityType in ipairs(battlegroundActivityTypes) do
        local locationSetsData = ZO_AFRM.locationSetsLookupData[activityType]
        if locationSetsData then
            for _, setLocation in pairs(locationSetsData) do
                if setLocation:DoesPlayerMeetLevelRequirements() and not setLocation:IsLocked() then
                    location = setLocation
                    break
                end
            end
        end
        if location then break end
    end

    if not location then
        LibPanicida.Debug.LogLater("No eligible battleground found")
        return
    end

    ZO_AFRM:SetLocationSelected(location, true)
    location:AddActivitySearchEntry()

    local result = StartActivityFinderSearch()
    if result ~= ACTIVITY_QUEUE_RESULT_SUCCESS then
        ZO_AlertEvent(EVENT_ACTIVITY_QUEUE_RESULT, result)
    else
        LibPanicida.Debug.LogLater(zo_strformat(GAFE.Loc("QueueForActivity"),
            GetString(SI_LFGACTIVITY4),
            GetString(SI_GROUPFINDERCATEGORY_SINGLESELECTDEFAULT0)
        ))
    end
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
