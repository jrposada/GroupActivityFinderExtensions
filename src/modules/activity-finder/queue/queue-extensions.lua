local GAFE = GroupActivityFinderExtensions

local autoConfirmCheckbox
local timerLabel

local function RefreshAutoConfirmEvents()
    local savedVars = GAFE.SavedVars
    local eventName = GAFE.name.."_QueueExtensions_AutoConfirm"
    local loopSoundEventName = GAFE.name.."_QueueExtensions_LoopSound"

    local function LoopSound()
        if GetActivityFinderStatus() ~= ACTIVITY_FINDER_STATUS_READY_CHECK or HasAcceptedLFGReadyCheck() then
            EVENT_MANAGER:UnregisterForUpdate(loopSoundEventName)
        else
            PlaySound(SOUNDS.LFG_SEARCH_FINISHED)
        end
    end

    local function OnActivityFinderStatusChange(_, status)
        if status==ACTIVITY_FINDER_STATUS_READY_CHECK and not IsActiveWorldBattleground() then
            if savedVars.autoConfirm.enabled and savedVars.autoConfirm.value then
                GAFE.CallLater("ReadyCheck", GAFE.SavedVars.autoConfirm.delay, AcceptLFGReadyCheckNotification)
            end

            if savedVars.autoConfirm.loopSound then
                EVENT_MANAGER:RegisterForUpdate(loopSoundEventName, 2000, LoopSound)
            end
        end
    end

    if (savedVars.autoConfirm.enabled and savedVars.autoConfirm.value) or savedVars.autoConfirm.loopSound then
        EVENT_MANAGER:RegisterForEvent(eventName, EVENT_PLAYER_ACTIVATED, function()
            EVENT_MANAGER:RegisterForEvent(eventName, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, OnActivityFinderStatusChange)
        end)
        EVENT_MANAGER:RegisterForEvent(eventName, EVENT_PLAYER_DEACTIVATED, function()
            EVENT_MANAGER:UnregisterForEvent(eventName, EVENT_ACTIVITY_FINDER_STATUS_UPDATE)
        end)
    else
        EVENT_MANAGER:UnregisterForEvent(eventName, EVENT_ACTIVITY_FINDER_STATUS_UPDATE)
        EVENT_MANAGER:UnregisterForEvent(eventName, EVENT_PLAYER_ACTIVATED)
        EVENT_MANAGER:UnregisterForEvent(eventName, EVENT_PLAYER_DEACTIVATED)
    end
end

GAFE_QUEUE_EXTENSIONS = {}

function GAFE_QUEUE_EXTENSIONS.Init()
    local savedVars = GAFE.SavedVars

    local function InitializeAutoConfirm()
        local function ToggleAutoConfirm()
            savedVars.autoConfirm.value = not savedVars.autoConfirm.value
            autoConfirmCheckbox.GAFE_SetChecked(savedVars.autoConfirm.value)
            RefreshAutoConfirmEvents()
        end

        -- Create control
        local parent=ZO_SearchingForGroupStatus
        if parent then
            autoConfirmCheckbox=GAFE.UI.Checkbox("GAFE_AutoConfirmActivity", parent, {200,28}, {BOTTOM,parent,TOP,0,0}, GAFE.Loc("AutoConfirm"), ToggleAutoConfirm, true, savedVars.autoConfirm.value, not savedVars.autoConfirm.enabled)
        end

        -- Init events
        RefreshAutoConfirmEvents()
    end

    local function InitializeTimer()
        local ACTUAL_HEADER_TEXT = GetString(SI_GAMEPAD_LFG_QUEUE_ACTUAL)
        local NO_ICON = ""
        local registered = false

        local function UpdateTimer()
            local searchStartTimeMs = GetLFGSearchTimes()
            local timeSinceSearchStartMs = GetFrameTimeMilliseconds() - searchStartTimeMs
            local textStartTime = ZO_FormatTimeMilliseconds(timeSinceSearchStartMs, TIME_FORMAT_STYLE_COLONS, TIME_FORMAT_PRECISION_TWELVE_HOUR)

            timerLabel:SetText(zo_strformat(SI_ACTIVITY_QUEUE_STATUS_LABEL_FORMAT, ACTUAL_HEADER_TEXT, NO_ICON, textStartTime))
        end

        local function OnActivityFinderStatusUpdate(status)
            if (status == ACTIVITY_FINDER_STATUS_QUEUED and not registered) then
                registered = true
                UpdateTimer()
                EVENT_MANAGER:RegisterForUpdate(GAFE.name.."_QueueExtensions_Timer", 1000, UpdateTimer)
            elseif status ~= ACTIVITY_FINDER_STATUS_QUEUED and registered then
                registered = false
                EVENT_MANAGER:UnregisterForUpdate(GAFE.name.."_QueueExtensions_Timer")
            end
        end

        -- Create label control
        local parent = ZO_ActivityTrackerContainerSubLabel
        timerLabel = GAFE.UI.Label("GAFE_ActivityTracker_QueueTimer", parent, {125,20}, {LEFT,parent,LEFT,0,20}, "ZoFontGameShadow", nil, {0,1})

        ZO_ACTIVITY_FINDER_ROOT_MANAGER:RegisterCallback("OnActivityFinderStatusUpdate", OnActivityFinderStatusUpdate)
    end

    InitializeAutoConfirm()
    InitializeTimer()
end

function GAFE_QUEUE_EXTENSIONS.AutoConfirm(enable)
    local savedVars = GAFE.SavedVars
    savedVars.autoConfirm.enabled = enable
    autoConfirmCheckbox:SetHidden(not enable)
    RefreshAutoConfirmEvents()
end
