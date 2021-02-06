local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER

GAFE.AutoConfirm = {}

local function AutoConfirm()
	local autoConfirm

	local function RefreshAutoConfirmEvents()
		local saveData = GAFE.SavedVars
		local eventName=GAFE.name.."_ActivityFinderStatusUpdate"
		if saveData.autoConfirm then
			EM:RegisterForEvent(eventName, EVENT_PLAYER_ACTIVATED, function()
				EM:RegisterForEvent(eventName, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, function(_,status)
					if status==ACTIVITY_FINDER_STATUS_READY_CHECK and not IsActiveWorldBattleground() then
						GAFE.CallLater("ReadyCheck", 1000, AcceptLFGReadyCheckNotification)
					end
				end)
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

	local function ToggleAutoConfirm()
		local saveData = GAFE.SavedVars
		saveData.autoConfirm = not saveData.autoConfirm
		autoConfirm.GAFE_SetChecked(saveData.autoConfirm)
		RefreshAutoConfirmEvents()
	end

	-- Auto confirm checkbox
	local parent=ZO_SearchingForGroupStatus
	if parent then
		local saveData = GAFE.SavedVars
		autoConfirm=GAFE_AutoConfirmActivity or GAFE.UI.Checkbox("GAFE_AutoConfirmActivity", parent, {200,28}, {BOTTOM,parent,TOP,0,0}, GAFE.Loc("AutoConfirm"), ToggleAutoConfirm, true, saveData.autoConfirm)
	end
	RefreshAutoConfirmEvents()
end

function GAFE.AutoConfirm.Init()
	AutoConfirm()
end