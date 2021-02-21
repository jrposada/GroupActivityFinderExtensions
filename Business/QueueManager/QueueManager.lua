local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER
local TrialActivityData = GAFE.TrialActivityData

GAFE.QueueManager = {}

---------------------
-- Local constants --
---------------------
local QueueInfoType = {
	Type = 1,
	Role = 2,
	Activity = 3
}
local Type = {
	Lfg = 1,
	Lfm = 2
}
local TypeText = {
	[Type.Lfg] = "LFG",
	[Type.Lfm] = "LFM"
}
local RoleText = {
	[LFG_ROLE_DPS] = "DD",
	[LFG_ROLE_HEAL] = "H",
	[LFG_ROLE_TANK] = "T"
}

---------------------
-- Local variables --
---------------------
local isQueued = false
local joinQueueCheckbox = nil
local roleTarget = {
	[LFG_ROLE_DPS] = 8,
	[LFG_ROLE_HEAL] = 2,
	[LFG_ROLE_TANK] = 2
}
local queueWordList
local queueInfo = {
    [QueueInfoType.Type] = nil,
    [QueueInfoType.Role] = nil,
    [QueueInfoType.Activity] = nil
}

local function CanQueue()
    return queueInfo[QueueInfoType.Type] ~= nil and queueInfo[QueueInfoType.Role] ~= nil and queueInfo[QueueInfoType.Activity] ~= nil
end

local function SetIsQueued(value)
	isQueued = value
	joinQueueCheckbox.GAFE_SetChecked(isQueued)
	joinQueueCheckbox:SetState(CanQueue() and BSTATE_NORMAL or BSTATE_DISABLED)
end

local function ToggleIsQueued()
    SetIsQueued((not isQueued) and CanQueue())
end

local function HandleMessage(event, channelType, fromName, messageText, isCustomerService, fromDisplayName)
    local function ParseQueueInfo(words, numWords)
        local parsedInfo = {}
        for w = 1, numWords do
            local word = words[w]:lower()
            local wordInfo = queueWordList[word]
            if wordInfo ~= nil then
                table.insert(parsedInfo[wordInfo], word)
            end
        end

        -- Validate queueInfo
        if parsedInfo[QueueInfoType.Type] == nil or parsedInfo[QueueInfoType.Role] == nil or parsedInfo[QueueInfoType.Activity] == nil then
            parsedInfo = nil
        end

        return parsedInfo
    end

    local function QueueInfoIsMatch(parsedQueueInfo)
        local isMatch = false

        GAFE.LogLater("TODO")

        return isMatch
    end

    local function SendJoin(toDisplayName)
        GAFE.LogLater("TODO: Send invite/wishper to "..toDisplayName)
    end

    if isQueued then
        local words, numWords = GAFE.Split(messageText, " ")
        -- Only parse message shorter than X words. We don't want to parse hole conversations...
        if numWords <= 10 then
            local parsedQueueInfo = ParseQueueInfo(words, numWords)
            if parsedQueueInfo ~= nil then
                local displayName = GetDisplayName()
                if fromDisplayName ~= displayName then
                    -- Os other player's message
                    if QueueInfoIsMatch(parsedQueueInfo) then
                        SendJoin(fromDisplayName)
                    end
                else
                    -- Is our message
                    queueInfo = parsedQueueInfo
                end
            end
        end
    end
end

local function RefreshEvents()
    local savedVars = GAFE.SavedVars
	local eventName = GAFE.name.."_QueueChatMessage"
	if savedVars.autoInvite.enabled and isQueued then
		EM:RegisterForEvent(eventName, EVENT_CHAT_MESSAGE_CHANNEL, HandleMessage)
	else
		EM:UnregisterForEvent(eventName, EVENT_CHAT_MESSAGE_CHANNEL)
	end
end

function GAFE.QueueManager.Init()
	queueWordList = {
		[TypeText[Type.Lfg]:lower()] = QueueInfoType.Type,
		[TypeText[Type.Lfm]:lower()] = QueueInfoType.Type,
		[RoleText[LFG_ROLE_TANK]:lower()] = QueueInfoType.Role,
		[RoleText[LFG_ROLE_HEAL]:lower()] = QueueInfoType.Role,
		[RoleText[LFG_ROLE_DPS]:lower()] = QueueInfoType.Role,
	}
	for _, data in pairs(TrialActivityData) do
		queueWordList[data.lf:lower()] = QueueInfoType.Activity
	end

	-- Create Auto Invite checkbox
	local parent=ZO_SearchingForGroupStatus
	if parent then
        local isEnabled = GAFE.SavedVars.autoInvite.enabled
		joinQueueCheckbox=GAFE.UI.Checkbox(GAFE.name.."_AutoInvite", parent, {200,28}, {BOTTOM,parent,TOP,0,-25}, GAFE.Loc("AutoInvite"), ToggleIsQueued, CanQueue(), isQueued, not isEnabled)
	end

    RefreshEvents()
end

function GAFE.QueueManager.Enable(enabled)
    local savedVars = GAFE.SavedVars
    savedVars.autoInvite.enabled = enabled
    joinQueueCheckbox:SetHidden(not enabled)
    RefreshEvents()
end

function GAFE.QueueManager.Lfg(activities, numActivities)
	local message = RoleText[GetSelectedLFGRole()].." "..TypeText[Type.Lfg]

	for i = 1, numActivities do
		message = message.." "..TrialActivityData[activities[i]].lf
	end

	GAFE.Chat.SendMessage(message)
	SetIsQueued(false)
end

function GAFE.QueueManager.Lfm(activities, numActivities)
	local message = TypeText[Type.Lfm]
	for i = 1, numActivities do
		message = message.." "..TrialActivityData[activities[i]].lf
	end

	-- Group composition
	local dd, t, h = 0, 0, 0
	local groupSize = GetGroupSize()
	if groupSize ~= 0 then
		for unitIndex=1, groupSize do
			local unitTag = GetGroupUnitTagByIndex(unitIndex)
			local role = GetGroupMemberSelectedRole(unitTag)

			if role == LFG_ROLE_DPS then
				dd = dd + 1
			elseif role == LFG_ROLE_HEAL then
				h = h + 1
			elseif role == LFG_ROLE_TANK then
				t = t + 1
			end
		end
	else
		local role = GetSelectedLFGRole()

		if role == LFG_ROLE_DPS then
			dd = dd + 1
		elseif role == LFG_ROLE_HEAL then
			h = h + 1
		elseif role == LFG_ROLE_TANK then
			t = t + 1
		end
	end

	if t ~= roleTarget[LFG_ROLE_TANK] then
		message = message.." "..(roleTarget[LFG_ROLE_TANK] - t)..RoleText[LFG_ROLE_TANK]
	end
	if h ~= roleTarget[LFG_ROLE_HEAL] then
		message = message.." "..(roleTarget[LFG_ROLE_HEAL] - h)..RoleText[LFG_ROLE_HEAL]
	end
	if dd ~= roleTarget[LFG_ROLE_DPS] then
		message = message.." "..(roleTarget[LFG_ROLE_DPS] - dd)..RoleText[LFG_ROLE_DPS]
	end

	GAFE.Chat.SendMessage(message)
	SetIsQueued(false)
end

function GAFE.QueueManager.GetRoleText(role)
    return RoleText[role]
end

function GAFE.QueueManager.GetRoleTarget(role)
    return roleTarget[role]
end

function GAFE.QueueManager.SetRoleTarget(role, value)
    roleTarget[role] = value
end