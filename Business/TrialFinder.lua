local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER
local ActivityId = GAFE.Constants.ActivityId
local TrialQuest = GAFE.TrialChestTimer.TrialQuest

GAFE.TrialFinder = {}

-- https://esoitem.uesp.net/viewlog.php
local TrialData={
    --Normal
    [ActivityId.NormalAetherianArchive]     = {  lf="nAA",	node=231,	q=TrialQuest.AetherianArchive,		id=990,		hm=1137,	tt=1081,	nd=false },
    [ActivityId.NormalHelRaCitadel]         = {  lf="nHRC",	node=230,	q=TrialQuest.HelRaCitadel,			id=991,		hm=1136,	tt=1080,	nd=false },
    [ActivityId.NormalSanctumOphidia]       = {  lf="nSO",	node=232,	q=TrialQuest.SanctumOphidia,		id=1123,	hm=1138,	tt=1124,	nd=false },
    [ActivityId.NormalMawOfLorkhaj]         = {  lf="nMOL",	node=258,	q=TrialQuest.MawOfLorkhaj,			id=nil },
    [ActivityId.NormalHallsOfFabrication]   = {  lf="nHOF",	node=331,	q=TrialQuest.HallsOfFabrication,	id=nil },
    [ActivityId.NormalAsylumSanctorium]     = {  lf="nAS",	node=346,	q=TrialQuest.AsylumSanctorium,		id=nil },
    [ActivityId.NormalCloudrest]            = {  lf="nCR",	node=364,	q=TrialQuest.Cloudrest,				id=nil },
    [ActivityId.NormalSunspire]             = {  lf="nSS",	node=399,	q=TrialQuest.Sunspire,				id=nil },
    [ActivityId.NormalKynesAegis]           = {  lf="nKA",	node=434,	q=TrialQuest.KynesAegis,			id=nil },
    --Veteran
    [ActivityId.VeteranAetherianArchive]     = { lf="vAA",	node=231,	q=TrialQuest.AetherianArchive,		id=1503,	hm=false,	tt=false,	nd=false },
    [ActivityId.VeteranHelRaCitadel]         = { lf="vHRC",	node=230,	q=TrialQuest.HelRaCitadel,			id=1474,	hm=870,		tt=false,	nd=false },
    [ActivityId.VeteranSanctumOphidia]       = { lf="vSO",	node=232,	q=TrialQuest.SanctumOphidia,		id=1462,	hm=false,	tt=false,	nd=false },
    [ActivityId.VeteranMawOfLorkhaj]         = { lf="vMOL",	node=258,	q=TrialQuest.MawOfLorkhaj,			id=nil,	hm=nil,	tt=nil,	nd=nil },
    [ActivityId.VeteranHallsOfFabrication]   = { lf="vHOF",	node=331,	q=TrialQuest.HallsOfFabrication,	id=nil,	hm=nil,	tt=nil,	nd=nil },
    [ActivityId.VeteranAsylumSanctorium]     = { lf="vAS",	node=346,	q=TrialQuest.AsylumSanctorium,		id=nil,	hm=nil,	tt=nil,	nd=nil },
    [ActivityId.VeteranCloudrest]            = { lf="vCR",	node=364,	q=TrialQuest.Cloudrest,				id=nil,	hm=nil,	tt=nil,	nd=nil },
    [ActivityId.VeteranSunspire]             = { lf="vSS",	node=399,	q=TrialQuest.Sunspire,				id=nil,	hm=nil,	tt=nil,	nd=nil },
    [ActivityId.VeteranKynesAegis]           = { lf="vKA",	node=434,	q=TrialQuest.KynesAegis,			id=nil,	hm=nil,	tt=nil,	nd=nil }
}


-- local function GetGoalPledges()
--     local pledgeQuests, havePledge = {}, false
--     for i=1, MAX_JOURNAL_QUESTS do
--         local name,_,_,stepType,_,completed,_,_,_,questType,instanceType=GetJournalQuestInfo(i)
--         if name and name~="" and not completed and questType==QUEST_TYPE_UNDAUNTED_PLEDGE and instanceType==INSTANCE_TYPE_GROUP then
--             local text=string.format("%s",name:gsub(".*:%s*",""):gsub(" "," "):lower())
--             pledgeQuests[text]=stepType~=QUEST_STEP_TYPE_AND
--             if stepType==QUEST_STEP_TYPE_AND then havePledge=true end
-- 		end
--     end
--     return pledgeQuests, havePledge
-- end

local function TrialFinder()
    -- local pledgeQuests, havePledge, haveQuests={}, false, false
	-- local day=math.floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1517464800)/86400)

	local roleText = {
		[LFG_ROLE_DPS] = "DD",
		[LFG_ROLE_HEAL] = "H",
		[LFG_ROLE_TANK] = "T"
	}

	local targetDd, targetT, targetH = 8, 2, 2

	local function UpdateTargetTank(value)
		targetT = value
	end

	local function UpdateTargetHeal(value)
		targetH = value
	end

	local function UpdateTargetDd(value)
		targetDd = value
	end

	local function Lfg()
		local message = roleText[GetSelectedLFGRole()]

		message = message.." LFG"
		for c=2,3 do
			local parent=_G["GAFE_TrialFinder_KeyboardListSectionScrollChildContainer"..c]
			if parent then
				for i=1,parent:GetNumChildren() do
					local obj=parent:GetChild(i)
					if obj and obj.check:GetState()==BSTATE_PRESSED then
						local activityId = obj.node.data.id
						message = message.." "..TrialData[activityId].lf
					end
				end
			end
		end

		GAFE.Chat.SendMessage(message)
	end

    local function Lfm()
		local message = "LFM"
		for c=2,3 do
			local parent=_G["GAFE_TrialFinder_KeyboardListSectionScrollChildContainer"..c]
			if parent then
				for i=1,parent:GetNumChildren() do
					local obj=parent:GetChild(i)
					if obj and obj.check:GetState()==BSTATE_PRESSED then
						local activityId = obj.node.data.id
						message = message.." "..TrialData[activityId].lf
					end
				end
			end
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

		if t ~= targetT then
			message = message.." "..(targetT - t)..roleText[LFG_ROLE_TANK]
		end
		if h ~= targetH then
			message = message.." "..(targetH - h)..roleText[LFG_ROLE_HEAL]
		end
		if dd ~= targetDd then
			message = message.." "..(targetDd - dd)..roleText[LFG_ROLE_DPS]
		end

		GAFE.Chat.SendMessage(message)
	end

	local function IsAnythingSelected()
		local isAnythingSelected = false
		for c=2,3 do
			local parent=_G["GAFE_TrialFinder_KeyboardListSectionScrollChildContainer"..c]
			if parent then
				for i=1,parent:GetNumChildren() do
					local obj=parent:GetChild(i)
					if obj then
						isAnythingSelected = isAnythingSelected or obj.check:GetState()==BSTATE_PRESSED
					end
				end
			end
		end
		return isAnythingSelected
	end

	local function CanLfg(isAnythingSelected)
		return isAnythingSelected and GetGroupSize() == 0
	end

	local function CanLfm(isAnythingSelected)
		return isAnythingSelected and (GetGroupSize() == 0 or IsUnitGroupLeader("player"))
	end

	local function RefreshControls()
		local controls = GAFE.UI.Controls
		local lfgButton = controls.LfgButton

		local isAnythingSelected = IsAnythingSelected()

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
		local lfmButton = controls.LfmButton
		if lfmButton then
			local tooltipText = nil
			if isAnythingSelected and (not canLfm) then
				tooltipText = GAFE.Loc("LookForMoreDisabled")
			end
			lfmButton:SetState(canLfm and BSTATE_NORMAL or BSTATE_DISABLED)
			GAFE.UI.SetTooltip(lfgButton, tooltipText)
		end

		local counterTs = controls.CounterTs
		if counterTs then
			counterTs:SetHidden(not canLfm)
		end

		local counterHs = controls.CounterHs
		if counterHs then
			counterHs:SetHidden(not canLfm)
		end

		local counterDds = controls.CounterDds
		if counterDds then
			counterDds:SetHidden(not canLfm)
		end
	end

	local function FastTravel(nodeIndex)
		local _, name = GetFastTravelNodeInfo(nodeIndex)
		ZO_Dialogs_ShowPlatformDialog("RECALL_CONFIRM", {nodeIndex = nodeIndex}, {mainTextParams = {name}})
	end

	local function ParseTimeStamp(timeStamp)
		local seconds = timeStamp

		local days = math.floor(seconds / 86400) -- 1 day
		seconds = seconds - (days * 86400)

		local hours = math.floor(seconds / 3600) -- 1 hour
		seconds = seconds - (hours * 3600)

		local mins = math.floor(seconds / 60) -- 1 min
		seconds = seconds - (mins * 60)

		return string.format("%01.f %01.f:%01.f:%01.f", days, hours, mins, seconds)
	end

	local function UpdateChestLabel(label, characterId, questId)
		local chestText
		local timeUntilNextChest = GAFE.TrialChestTimer.GetTimeUntilNextChest(characterId, questId)
		if timeUntilNextChest > 0 then
			chestText = ParseTimeStamp(timeUntilNextChest)
		else
			chestText = "|t20:20:/esoui/art/icons/mail_armor_container.dds|t"
		end
		label:SetText(chestText)
	end

	local function AddTrialElements()
		-- Get player difficulty mode
		local difficultyMode = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 3 or 2 -- Normal => 2, Veteran => 3
		local characterId = GetCurrentCharacterId()

		for c=2,3 do
			local parent=_G["GAFE_TrialFinder_KeyboardListSectionScrollChildContainer"..c]
			if parent then
				for i=1,parent:GetNumChildren() do
					local obj=parent:GetChild(i)
					if obj then
						local activityId=obj.node.data.id
                        if TrialData[activityId] then
							local debug = GetDisplayName() == "@Panicida"

							-- Teleport button
							local nodeIndex = TrialData[activityId].node
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
							local chestLabel = GAFE.UI.Label(GAFE.name.."_TrialInfo_Chest"..c..i, obj, {60,20}, {LEFT,obj,LEFT,400,3}, "ZoFontGameSmall", nil, {0,1}, "")
							UpdateChestLabel(chestLabel, characterId, TrialData[activityId].q)
							chestLabel:SetHandler("OnUpdate", function() UpdateChestLabel(chestLabel, characterId, TrialData[activityId].q) end)

							-- local weeklyLabel = GAFE.UI.Label(GAFE.name.."_TrialInfo_Weekly"..c..i, obj, {125,20}, {LEFT,obj,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, "")

							-- General Vanquisher (normal) / Conqueror (veteran)
							local idText
							if TrialData[activityId].id then
								idText=IsAchievementComplete(TrialData[activityId].id) and "|t20:20:/esoui/art/announcewindow/announcement_icon_up.dds|t" or ""
							elseif debug and TrialData[activityId].id == nil then
								idText="i"
							end
							GAFE.UI.Label(GAFE.name.."_TrialInfo_Achievements_id"..c..i, obj, {20,20}, {LEFT,obj,LEFT,460,0}, "ZoFontGameLarge", nil, {0,1}, idText)

							-- Death challenge (hard mode)
							local hardModeText
							if TrialData[activityId].hm then
								hardModeText=IsAchievementComplete(TrialData[activityId].hm) and "|t20:20:/esoui/art/unitframes/target_veteranrank_icon.dds|t" or ""
							elseif debug and TrialData[activityId].hm == nil then
								hardModeText="h"
							end
							GAFE.UI.Label(GAFE.name.."_TrialInfo_Achievements_hm"..c..i, obj, {20,20}, {LEFT,obj,LEFT,480,0}, "ZoFontGameLarge", nil, {0,1}, hardModeText)

							-- Speed challenge
							local speedText
							if TrialData[activityId].tt then
								speedText=IsAchievementComplete(TrialData[activityId].tt) and "|t20:20:/esoui/art/ava/overview_icon_underdog_score.dds|t" or ""
							elseif debug and TrialData[activityId].tt == nil then
								speedText="t"
							end
							GAFE.UI.Label(GAFE.name.."_TrialInfo_Achievements_tt"..c..i, obj, {20,20}, {LEFT,obj,LEFT,500,0}, "ZoFontGameLarge", nil, {0,1}, speedText)

							-- Survivor challenge (no death)
							local noDeathText
							if TrialData[activityId].nd then
								noDeathText=IsAchievementComplete(TrialData[activityId].nd) and "|t20:20:/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds|t" or ""
							elseif debug and TrialData[activityId].nd == nil then
								noDeathText="n"
							end
							GAFE.UI.Label(GAFE.name.."_TrialInfo_Achievements_nd"..c..i, obj, {20,20}, {LEFT,obj,LEFT,520,0}, "ZoFontGameLarge", nil, {0,1}, noDeathText)

						-- 	-- Quest
						-- 	-- obj.quest = GetCompletedQuestInfo(TrialData[id].q) == "" and true or false
						-- 	-- haveQuests = haveQuests or obj.quest
						else
							local todo = GAFE.UI.Label(GAFE.name.."_TrialInfo_Todo"..c..i, obj, {125,20}, {LEFT,obj,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, "TODO:"..activityId)
						end

						obj:SetHandler("OnMouseUp", function() RefreshControls() end, GAFE.name)
					end
				end
			end

			-- Collapse corresponding panel depending on dungeon mode
			local header=_G["GAFE_TrialFinder_KeyboardListSectionScrollChildZO_ActivityFinderTemplateNavigationHeader_Keyboard"..c-1]
			if header then
				local state=header.text:GetColor()
				if ((difficultyMode==c)==(state==1)) then header:OnMouseUp(true) end
			end
        end

		RefreshControls()
	end

	local parent=GAFE_TrialFinder_Keyboard
	if parent then
		-- Create buttons lf
		local w=parent:GetWidth()
		local dims = {200,28}
		local canLfg = CanLfg()
		local canLfm = CanLfm()

		local controls = GAFE.UI.Controls
		controls.LfgButton=GAFE.UI.ZOButton("GAFE_LookForGroup", parent, dims, {BOTTOM,parent,BOTTOM,w/3,0}, GAFE.Loc("LookForGroup"), Lfg, canLfg)
		controls.LfmButton=GAFE.UI.ZOButton("GAFE_LookForMore", parent, dims, {BOTTOM,parent,BOTTOM,0,0}, GAFE.Loc("LookForMore"), Lfm, canLfm)

		-- Create party composition controls
		dims = {65,40}
		controls.CounterTs = GAFE.UI.Counter(GAFE.name.."_Group_ts", parent, dims, {BOTTOM,parent,BOTTOM,-w/3,-35}, nil, roleText[LFG_ROLE_TANK], targetT, UpdateTargetTank, not canLfm)
		controls.CounterHs = GAFE.UI.Counter(GAFE.name.."_Group_hl", parent, dims, {BOTTOM,parent,BOTTOM,0,-35}, nil, roleText[LFG_ROLE_HEAL], targetH, UpdateTargetHeal, not canLfm)
		controls.CounterDds = GAFE.UI.Counter(GAFE.name.."_Group_dds", parent, dims, {BOTTOM,parent,BOTTOM,w/3,-35}, nil, roleText[LFG_ROLE_DPS], targetDd, UpdateTargetDd, not canLfm)
	end

    -- Hide queue button.
    local queueButton = GAFE_TrialFinder_KeyboardQueueButton
    if queueButton then
        queueButton:SetHidden(true)
    end

    ZO_PreHookHandler(GAFE_TrialFinder_KeyboardListSection, 'OnEffectivelyShown', function() GAFE.CallLater("AddTrialElements",200,AddTrialElements) end)
	-- ZO_PreHookHandler(ZO_TrialFinder_KeyboardListSection, 'OnEffectivelyHidden', function()  end)

	EM:RegisterForEvent(GAFE.name.."_GroupMemberJoined", EVENT_GROUP_MEMBER_JOINED, RefreshControls)
	EM:RegisterForEvent(GAFE.name.."_GroupMemberLeft", EVENT_GROUP_MEMBER_LEFT, RefreshControls)
	EM:RegisterForEvent(GAFE.name.."_LeaderUpdated", EVENT_LEADER_UPDATE, RefreshControls)
end

function GAFE.TrialFinder.Init()
	TrialFinder()
end