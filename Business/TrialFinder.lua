local GAFE = GroupActivityFinderExtensions
local TFD = GAFE.TrialFinderData
local EM = EVENT_MANAGER
local ActivityId = GAFE.Constants.ActivityId

GAFE.TrialFinder = {}

-- https://esoitem.uesp.net/viewlog.php
local TrialData={
    --Normal
    [ActivityId.NormalAetherianArchive]     = {  lf="nAA",	id=nil },
    [ActivityId.NormalHelRaCitadel]         = {  lf="nHRC",	id=nil },
    [ActivityId.NormalSanctumOphidia]       = {  lf="nSO",	id=nil },
    [ActivityId.NormalMawOfLorkhaj]         = {  lf="nMOL",	id=nil },
    [ActivityId.NormalHallsOfFabrication]   = {  lf="nHOF",	id=nil },
    [ActivityId.NormalAsylumSanctorium]     = {  lf="nAS",	id=nil },
    [ActivityId.NormalCloudrest]            = {  lf="nCR",	id=nil },
    [ActivityId.NormalSunspire]             = {  lf="nSS",	id=nil },
    [ActivityId.NormalKynesAegis]           = {  lf="nKA",	id=nil },
    --Veteran
    [ActivityId.VeteranAetherianArchive]     = { lf="vAA",	 id=nil,    hm=nil,    tt=nil,    nd=nil },
    [ActivityId.VeteranHelRaCitadel]         = { lf="vHRC",	 id=nil,    hm=nil,    tt=nil,    nd=nil },
    [ActivityId.VeteranSanctumOphidia]       = { lf="vSO",	 id=nil,    hm=nil,    tt=nil,    nd=nil },
    [ActivityId.VeteranMawOfLorkhaj]         = { lf="vMOL",	 id=nil,    hm=nil,    tt=nil,    nd=nil },
    [ActivityId.VeteranHallsOfFabrication]   = { lf="vHOF",	 id=nil,    hm=nil,    tt=nil,    nd=nil },
    [ActivityId.VeteranAsylumSanctorium]     = { lf="vAS",	 id=nil,    hm=nil,    tt=nil,    nd=nil },
    [ActivityId.VeteranCloudrest]            = { lf="vCR",	 id=nil,    hm=nil,    tt=nil,    nd=nil },
    [ActivityId.VeteranSunspire]             = { lf="vSS",	 id=nil,    hm=nil,    tt=nil,    nd=nil },
    [ActivityId.VeteranKynesAegis]           = { lf="vKA",	 id=nil,    hm=nil,    tt=nil,    nd=nil }
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
		[LFG_ROLE_DPS] = "dd",
		[LFG_ROLE_HEAL] = "h",
		[LFG_ROLE_TANK] = "t"
	}

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
		local targetDd, targetT, targetH = 8, 2, 2
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

	local function RefreshLfButtons()
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

		local lfmButton = controls.LfmButton
		if lfmButton then
			local tooltipText = nil
			local canLfm = CanLfm(isAnythingSelected)
			if isAnythingSelected and (not canLfm) then
				tooltipText = GAFE.Loc("LookForMoreDisabled")
			end
			lfmButton:SetState(canLfm and BSTATE_NORMAL or BSTATE_DISABLED)
			GAFE.UI.SetTooltip(lfgButton, tooltipText)
		end
	end

	local function AddTrialElements()
		-- Get player difficulty mode
		local difficultyMode = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 3 or 2 -- Normal => 2, Veteran => 3

		for c=2,3 do
			local parent=_G["GAFE_TrialFinder_KeyboardListSectionScrollChildContainer"..c]
			if parent then
				for i=1,parent:GetNumChildren() do
					local obj=parent:GetChild(i)
					if obj then
						local id=obj.node.data.id
                        if TrialData[id] then
                            local debug = GetDisplayName() == "@Panicida"

							local weeklyLabel = GAFE.UI.Label(GAFE.name.."_TrialInfo_Weekly"..c..i, obj, {125,20}, {LEFT,obj,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, "")

							local achivementText=""

							-- General Vanquisher (normal) / Conqueror (veteran)
							if TrialData[id].id then
								achivementText=achivementText..(IsAchievementComplete(TrialData[id].id) and "|t20:20:/esoui/art/announcewindow/announcement_icon_up.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."i"
							end

							-- Death challenge (hard mode)
							if TrialData[id].hm then
								achivementText=achivementText..(IsAchievementComplete(TrialData[id].hm) and "|t20:20:/esoui/art/unitframes/target_veteranrank_icon.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."h"
							end

							-- Speed challenge
							if TrialData[id].tt then
								achivementText=achivementText..(IsAchievementComplete(TrialData[id].tt) and "|t20:20:/esoui/art/ava/overview_icon_underdog_score.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."t"
							end

							-- Survivor challenge (no death)
							if TrialData[id].nd then
								achivementText=achivementText..(IsAchievementComplete(TrialData[id].nd) and "|t20:20:/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."n"
                            end

							local achievementsLabel = GAFE.UI.Label(GAFE.name.."_TrialInfo_Achievements"..c..i, weeklyLabel, {105,20}, {RIGHT,weeklyLabel,RIGHT,0,0}, "ZoFontGameLarge", nil, {0,1}, achivementText)

							-- Quest
							-- obj.quest = GetCompletedQuestInfo(TrialData[id].q) == "" and true or false
							-- haveQuests = haveQuests or obj.quest
						else
							local todo = GAFE.UI.Label(GAFE.name.."_TrialInfo"..c..i, obj, {125,20}, {LEFT,obj,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, "TODO:"..id)
						end

						obj:SetHandler("OnMouseUp", function() RefreshLfButtons() end, GAFE.name)
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

		RefreshLfButtons()
	end

	-- Create buttons lf
	local parent=GAFE_TrialFinder_Keyboard
	if parent then
		local w=parent:GetWidth()
		local dims = {200,28}

		local controls = GAFE.UI.Controls
		controls.LfgButton=GAFE.UI.Button("GAFE_LookForGroup", parent, dims, {BOTTOM,parent,BOTTOM,w/3,0}, GAFE.Loc("LookForGroup"), Lfg, CanLfg())
		controls.LfmButton=GAFE.UI.Button("GAFE_LookForMore", parent, dims, {BOTTOM,parent,BOTTOM,0,0}, GAFE.Loc("LookForMore"), Lfm, CanLfm())
	end

    -- Hide queue button.
    local queueButton = GAFE_TrialFinder_KeyboardQueueButton
    if queueButton then
        queueButton:SetHidden(true)
    end

    ZO_PreHookHandler(GAFE_TrialFinder_KeyboardListSection, 'OnEffectivelyShown', function() GAFE.CallLater("AddTrialElements",200,AddTrialElements) end)
	-- ZO_PreHookHandler(ZO_TrialFinder_KeyboardListSection, 'OnEffectivelyHidden', function()  end)

	EM:RegisterForEvent(GAFE.name.."_GroupMemberJoined", EVENT_GROUP_MEMBER_JOINED, RefreshLfButtons)
	EM:RegisterForEvent(GAFE.name.."_GroupMemberLeft", EVENT_GROUP_MEMBER_LEFT, RefreshLfButtons)
	EM:RegisterForEvent(GAFE.name.."_LeaderUpdated", EVENT_LEADER_UPDATE, RefreshLfButtons)
end

function GAFE.TrialFinder.Init()
	TrialFinder()
end