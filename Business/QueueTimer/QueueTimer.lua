local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER


GAFE.QueueTimer = {}

local control

local function UpdateTimer()
    local searchStartTimeMs = GetLFGSearchTimes()

    local timeSinceSearchStartMs = GetFrameTimeMilliseconds() - searchStartTimeMs
    local textStartTime = ZO_FormatTimeMilliseconds(timeSinceSearchStartMs, TIME_FORMAT_STYLE_COLONS, TIME_FORMAT_PRECISION_TWELVE_HOUR)

    control:SetText("Actual: "..textStartTime)
end

function GAFE.QueueTimer.Init()
    -- Create label control
    local parent = ZO_ActivityTrackerContainerSubLabel
    control = GAFE.UI.Label("GAFE_ActivityTracker", parent, {125,20}, {LEFT,parent,LEFT,0,20}, "ZoFontGameShadow", nil, {0,1})

    -- Register for update
    ZO_PreHookHandler(parent, 'OnEffectivelyShown', function()
        UpdateTimer()
        EM:RegisterForUpdate("GAFE_ActivityTracker_Update", 1000, UpdateTimer)
    end)
	ZO_PreHookHandler(parent, 'OnEffectivelyHidden', function() EM:UnregisterForUpdate("GAFE_ActivityTracker_Update") end)
end