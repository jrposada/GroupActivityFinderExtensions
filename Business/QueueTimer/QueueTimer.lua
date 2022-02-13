local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER


GAFE.QueueTimer = {}

local control
local searchStartTimeMs

local function UpdateTimer()
    local timeSinceSearchStartMs = GetFrameTimeMilliseconds() - searchStartTimeMs
    local textStartTime = ZO_FormatTimeMilliseconds(timeSinceSearchStartMs, TIME_FORMAT_STYLE_COLONS, TIME_FORMAT_PRECISION_TWELVE_HOUR)

    control:SetText("Actual: "..textStartTime)
end

local function OnActivityFinderStatusUpdate(code, status)
    if status == ACTIVITY_FINDER_STATUS_QUEUED then
        searchStartTimeMs = GetFrameTimeMilliseconds()
        control:SetHidden(false)
        UpdateTimer()
        EM:RegisterForUpdate("GAFE_ActivityTracker_Update", 1000, UpdateTimer)
    else
        EM:UnregisterForUpdate("GAFE_ActivityTracker_Update")
        control:SetHidden(true)
    end
end

function GAFE.QueueTimer.Init()
    -- Create label control
    local parent = ZO_ActivityTrackerContainerSubLabel
    control = GAFE.UI.Label("GAFE_ActivityTracker", parent, {125,20}, {LEFT,parent,LEFT,0,20}, "ZoFontGameShadow", nil, {0,1})

    EM:RegisterForEvent("GAFE_QueueTimer", EVENT_ACTIVITY_FINDER_STATUS_UPDATE, OnActivityFinderStatusUpdate)
end