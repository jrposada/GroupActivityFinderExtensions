local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER

GAFE.AutoConfirm = {}

local autoConfirmCheckbox

local function RefreshAutoConfirmEvents()
	local saveData = GAFE.SavedVars
	local eventName=GAFE.name.."_ActivityFinderStatusUpdate"
	if saveData.autoConfirm.enabled and saveData.autoConfirm.value then
		EM:RegisterForEvent(eventName, EVENT_PLAYER_ACTIVATED, function()
			EM:RegisterForEvent(eventName, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, function(_,status)
				if status==ACTIVITY_FINDER_STATUS_READY_CHECK and not IsActiveWorldBattleground() then
					GAFE.CallLater("ReadyCheck", 1000, AcceptLFGReadyCheckNotification)
				end
			end)
		end)
		EM:RegisterForEvent(eventName, EVENT_PLAYER_DEACTIVATED, function()
			EM:UnregisterForEvent(eventName, EVENT_ACTIVITY_FINDER_STATUS_UPDATE)
		end)
	else
		EM:UnregisterForEvent(eventName, EVENT_ACTIVITY_FINDER_STATUS_UPDATE)
		EM:UnregisterForEvent(eventName, EVENT_PLAYER_ACTIVATED)
		EM:UnregisterForEvent(eventName, EVENT_PLAYER_DEACTIVATED)
	end
end

local function AutoConfirm()
	local function ToggleAutoConfirm()
		local saveData = GAFE.SavedVars
		saveData.autoConfirm.value = not saveData.autoConfirm.value
		autoConfirmCheckbox.GAFE_SetChecked(saveData.autoConfirm.value)
		RefreshAutoConfirmEvents()
	end

	-- Create Auto confirm checkbox
	local parent=ZO_SearchingForGroupStatus
	if parent then
		local saveData = GAFE.SavedVars
		autoConfirmCheckbox=GAFE.UI.Checkbox("GAFE_AutoConfirmActivity", parent, {200,28}, {BOTTOM,parent,TOP,0,0}, GAFE.Loc("AutoConfirm"), ToggleAutoConfirm, true, saveData.autoConfirm.value, not saveData.autoConfirm.enabled)
	end

	RefreshAutoConfirmEvents()
end

function GAFE.AutoConfirm.Enable(enabled)
	local savedVars = GAFE.SavedVars
	savedVars.autoConfirm.enabled = enabled
	autoConfirmCheckbox:SetHidden(not enabled)
	RefreshAutoConfirmEvents()
end

function GAFE.AutoConfirm.Init()
	AutoConfirm()
end