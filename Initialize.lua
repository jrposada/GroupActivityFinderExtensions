-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
local DP = DailyPledges

-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
local function OnAddOnLoaded(eventCode, addonName)
    -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
    if addonName ~= DP.name then return end
	EVENT_MANAGER:UnregisterForEvent("DailyPledges_Event", EVENT_ADD_ON_LOADED)

    -- Load saved variables

    -- Initialize stuff
    DP.Automation_Init()
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent("DailyPledges_Event", EVENT_ADD_ON_LOADED, OnAddOnLoaded)