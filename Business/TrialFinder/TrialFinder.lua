local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER

local TrialActivityData = GAFE.TrialActivityData

GAFE.TrialFinder = {}

local finderActivityExtender = FinderActivityExtender:New("Trial", "GAFE")
local roleText = {
	[LFG_ROLE_DPS] = "DD",
	[LFG_ROLE_HEAL] = "H",
	[LFG_ROLE_TANK] = "T"
}
local roleTarget = {
	[LFG_ROLE_DPS] = 8,
	[LFG_ROLE_HEAL] = 2,
	[LFG_ROLE_TANK] = 2
}
local lfgButton
local lfmButton
local counterTs
local counterHs
local counterDds
local autoInviteCheckbox
local queuedInfo = {
	isQueued = false,
	type = nil,
	roles = nil,
	activities = nil

}
local isAutoInvite = false

local function CanAutoInvite()
	-- TODO: Implement
	return false
end

local function CanLfg(isAnythingSelected)
	return isAnythingSelected and GetGroupSize() == 0
end

local function CanLfm(isAnythingSelected)
	if isAnythingSelected then
		local _, count = finderActivityExtender:GetSelecteds()
		return count == 1 and (GetGroupSize() == 0 or IsUnitGroupLeader("player"))
	end
	return false
end

local function RefreshControls()
	local isAnythingSelected = finderActivityExtender:IsAnythingSelected()

	if lfgButton then
		local tooltipText = nil
		local canLfg = CanLfg(isAnythingSelected)
		if not canLfg then
			tooltipText = GAFE.Loc("LookForGroupDisabled")
		end
		lfgButton:SetState(canLfg and BSTATE_NORMAL or BSTATE_DISABLED)
		GAFE.UI.SetTooltip(lfgButton, tooltipText)
	end

	local canLfm = CanLfm(isAnythingSelected)
	if lfmButton then
		local tooltipText = nil
		if isAnythingSelected and (not canLfm) then
			tooltipText = GAFE.Loc("LookForMoreDisabled")
		end
		lfmButton:SetState(canLfm and BSTATE_NORMAL or BSTATE_DISABLED)
		GAFE.UI.SetTooltip(lfgButton, tooltipText)
	end

	if counterTs then
		counterTs:SetHidden(not canLfm)
	end

	if counterHs then
		counterHs:SetHidden(not canLfm)
	end

	if counterDds then
		counterDds:SetHidden(not canLfm)
	end
end

local function FastTravel(nodeIndex)
	local _, name = GetFastTravelNodeInfo(nodeIndex)
	ZO_Dialogs_ShowPlatformDialog("RECALL_CONFIRM", {nodeIndex = nodeIndex}, {mainTextParams = {name}})
end

local function UpdateChestLabel(label, characterId, questId)
	local chestText
	local timeUntilNextChest = GAFE.TrialChestTimer.GetTimeUntilNextChest(characterId, questId)
	if timeUntilNextChest > 0 then
		chestText = GAFE.ParseTimeStamp(timeUntilNextChest)
	else
		chestText =  finderActivityExtender:FormatTexture("/esoui/art/icons/mail_armor_container.dds")
	end
	label:SetText(chestText)
end

local function ExtendTrialActivity(obj, c, i, characterId)
	local activityId=obj.node.data.id
	if TrialActivityData[activityId] then
		local debug = GetDisplayName() == "@Panicida"

		-- Teleport button
		local nodeIndex = TrialActivityData[activityId].node
		if nodeIndex then
			local knownNode = GetFastTravelNodeInfo(nodeIndex)
			local teleportButton = GAFE.UI.Button(GAFE.name.."TrialInfo_Tp"..c..i, obj, {20,20}, {RIGHT,obj,LEFT,-5,0}, nil, function() FastTravel(nodeIndex) end, knownNode)
			if knownNode then
				teleportButton:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_complete.dds")
			else
				teleportButton:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_incomplete.dds")
			end
		end

		-- Chest label
		local chestLabel = finderActivityExtender:AddLabel(nil, "Chest"..c..i, obj, 370, 70)
		UpdateChestLabel(chestLabel, characterId, TrialActivityData[activityId].q)
		chestLabel:SetHandler("OnUpdate", function() UpdateChestLabel(chestLabel, characterId, TrialActivityData[activityId].q) end)

		-- General Vanquisher (normal) / Conqueror (veteran)
		finderActivityExtender:AddAchievement(TrialActivityData[activityId].id, "id"..c..i, obj, "/esoui/art/announcewindow/announcement_icon_up.dds", 440, debug)

		-- Death challenge (hard mode)
		finderActivityExtender:AddAchievement(TrialActivityData[activityId].hm, "hm"..c..i, obj, "/esoui/art/unitframes/target_veteranrank_icon.dds", 460, debug)

		-- Speed challenge
		finderActivityExtender:AddAchievement(TrialActivityData[activityId].tt, "tt"..c..i, obj, "/esoui/art/ava/overview_icon_underdog_score.dds", 480, debug)

		-- Survivor challenge (no death)
		finderActivityExtender:AddAchievement(TrialActivityData[activityId].nd, "nd"..c..i, obj, "/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds", 500, debug)
	else
		GAFE.UI.Label(GAFE.name.."_TrialInfo_Todo"..c..i, obj, {125,20}, {LEFT,obj,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, "TODO:"..activityId)
	end

	obj:SetHandler("OnMouseUp", function() RefreshControls() end, GAFE.name)
end

local function ParseMessage(event, channelType, fromName, messageText, isCustomerService, fromDisplayName)
	-- TODO: Remove true, its only for debugging
	local displayName = GetDisplayName()
	if isAutoInvite and queuedInfo.isQueued and (true or fromDisplayName ~= displayName) then
		local words, numWords = GAFE.Split(messageText, " ")

		-- Only parse message shorter than X words. We don't want to parse hole conversations...
		if numWords <= 10 then
			-- TODO: Implement
			-- If is lf message for queued params send invite / wishper
			GAFE.LogLater(words)
		end
	elseif fromDisplayName == displayName then
		local words, numWords = GAFE.Split(messageText, " ")

		-- Only parse message shorter than X words. We don't want to parse hole conversations...
		if numWords <= 10 then
			-- TODO: Implement
			-- If is lf message set up isQueued and needed params
			GAFE.LogLater(words)
		end
	end
end

local function ToggleAutoInvite()
	isAutoInvite = not isAutoInvite
	autoInviteCheckbox.GAFE_SetChecked(isAutoInvite)
	autoInviteCheckbox:SetState(CanAutoInvite() and BSTATE_NORMAL or BSTATE_DISABLED)
end

local function DisableAutoInvite()
	isAutoInvite = false
	autoInviteCheckbox.GAFE_SetChecked(isAutoInvite)
	autoInviteCheckbox:SetState(CanAutoInvite() and BSTATE_NORMAL or BSTATE_DISABLED)

	queuedInfo.type = nil
	queuedInfo.roles = nil
	queuedInfo.activities = nil
end

local function Lfg()
	local message = roleText[GetSelectedLFGRole()].." LFG"

	local selected, count = finderActivityExtender:GetSelecteds()
	for i = 1, count do
		message = message.." "..TrialActivityData[selected[i]].lf
	end

	GAFE.Chat.SendMessage(message)
	DisableAutoInvite()
end

local function Lfm()
	local message = "LFM"
	local selected, count = finderActivityExtender:GetSelecteds()
	for i = 1, count do
		message = message.." "..TrialActivityData[selected[i]].lf
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
		message = message.." "..(roleTarget[LFG_ROLE_TANK] - t)..roleText[LFG_ROLE_TANK]
	end
	if h ~= roleTarget[LFG_ROLE_HEAL] then
		message = message.." "..(roleTarget[LFG_ROLE_HEAL] - h)..roleText[LFG_ROLE_HEAL]
	end
	if dd ~= roleTarget[LFG_ROLE_DPS] then
		message = message.." "..(roleTarget[LFG_ROLE_DPS] - dd)..roleText[LFG_ROLE_DPS]
	end

	GAFE.Chat.SendMessage(message)
	DisableAutoInvite()
end

local function UpdateTargetTank(value)
	roleTarget[LFG_ROLE_TANK] = value
end

local function UpdateTargetHeal(value)
	roleTarget[LFG_ROLE_HEAL] = value
end

local function UpdateTargetDd(value)
	roleTarget[LFG_ROLE_DPS] = value
end

function GAFE.TrialFinder.Init()
	-- Panel buttons
	local parent=GAFE_TrialFinder_Keyboard
	if parent then
		-- Create lf buttons
		local w=parent:GetWidth()
		local dims = {200,28}
		local canLfg = CanLfg()
		local canLfm = CanLfm()

		lfgButton=GAFE.UI.ZOButton("GAFE_LookForGroup", parent, dims, {BOTTOM,parent,BOTTOM,w/3,0}, GAFE.Loc("LookForGroup"), Lfg, canLfg)
		lfmButton=GAFE.UI.ZOButton("GAFE_LookForMore", parent, dims, {BOTTOM,parent,BOTTOM,0,0}, GAFE.Loc("LookForMore"), Lfm, canLfm)

		-- Create party composition controls
		dims = {65,40}
		counterTs = GAFE.UI.Counter(GAFE.name.."_Group_ts", parent, dims, {BOTTOM,parent,BOTTOM,-w/3,-35}, nil, roleText[LFG_ROLE_TANK], roleTarget[LFG_ROLE_TANK], UpdateTargetTank, not canLfm)
		counterHs = GAFE.UI.Counter(GAFE.name.."_Group_hl", parent, dims, {BOTTOM,parent,BOTTOM,0,-35}, nil, roleText[LFG_ROLE_HEAL], roleTarget[LFG_ROLE_HEAL], UpdateTargetHeal, not canLfm)
		counterDds = GAFE.UI.Counter(GAFE.name.."_Group_dds", parent, dims, {BOTTOM,parent,BOTTOM,w/3,-35}, nil, roleText[LFG_ROLE_DPS], roleTarget[LFG_ROLE_DPS], UpdateTargetDd, not canLfm)

		-- Hide queue button.
		local queueButton = GAFE_TrialFinder_KeyboardQueueButton
		if queueButton then
			queueButton:SetHidden(true)
		end
	end

	-- Create Auto Invite checkbox
	local parent=ZO_SearchingForGroupStatus
	if parent then
		local canAutoInvite = CanAutoInvite()
		autoInviteCheckbox=GAFE.UI.Checkbox(GAFE.name.."_AutoInvite", parent, {200,28}, {BOTTOM,parent,TOP,0,-25}, GAFE.Loc("AutoInvite"), ToggleAutoInvite, canAutoInvite, isAutoInvite, false)
	end

	ZO_PreHookHandler(GAFE_TrialFinder_KeyboardListSection, 'OnEffectivelyShown', function()
		GAFE.CallLater("ExtendTrialActivity", 200, finderActivityExtender:ExtendFunc(ExtendTrialActivity, RefreshControls))
	end)

	EM:RegisterForEvent(GAFE.name.."_GroupMemberJoined", EVENT_GROUP_MEMBER_JOINED, RefreshControls)
	EM:RegisterForEvent(GAFE.name.."_GroupMemberLeft", EVENT_GROUP_MEMBER_LEFT, RefreshControls)
	EM:RegisterForEvent(GAFE.name.."_LeaderUpdated", EVENT_LEADER_UPDATE, RefreshControls)

	EM:RegisterForEvent(GAFE.name.."_ChatMessage", EVENT_CHAT_MESSAGE_CHANNEL, ParseMessage)
end