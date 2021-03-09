local GAFE = GroupActivityFinderExtensions

local PledgeQuestName = GAFE.DungeonPledgeQuestName
local PledgeList = GAFE.DungeonPledgeList
local DungeonActivityData = GAFE.DungeonActivityData

local AllianceId = {
	Aldmeri = 1,
	Daggerfall = 2,
	Ebonheart = 3
}

GAFE.DungeonFinder = {}

local finderActivityExtender = FinderActivityExtender:New("Dungeon", "ZO")
local todayPledges = {}
local pledgeQuests = {}
local havePledge = false
local haveQuests = false
local day
local checkQuestsButton
local checkPledgesButton

local function UpdateLocals()
	local function TodayPledges()
		todayPledges = {}
		for npc=1,3 do
			local dpList=PledgeList[npc]
			local n=1+(day+dpList.shift)%#dpList
			todayPledges[npc] = dpList[n]
		end
	end

	local function GoalPledges()
		pledgeQuests, havePledge = {}, false
		for i=1, MAX_JOURNAL_QUESTS do
			local name,_,_,stepType,_,completed,_,_,_,questType,instanceType=GetJournalQuestInfo(i)
			if name and name~="" and not completed and questType==QUEST_TYPE_UNDAUNTED_PLEDGE and instanceType==INSTANCE_TYPE_GROUP then
				local text=string.format("%s",name:gsub(".*:%s*",""):gsub(" "," "):lower())
				pledgeQuests[text]=stepType~=QUEST_STEP_TYPE_AND
				if stepType==QUEST_STEP_TYPE_AND then havePledge=true end
			end
		end
		return pledgeQuests, havePledge
	end

	local function Day()
		day=math.floor(GetDiffBetweenTimeStamps(GetTimeStamp(), 1517464800) / 86400) -- 86400 = 1 day
	end

	Day()
	TodayPledges()
	GoalPledges()
end

local function CheckPledges(obj)
	local activityType = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and LFG_ACTIVITY_DUNGEON or LFG_ACTIVITY_MASTER_DUNGEON
	return obj.pledge and obj.node.data:GetActivityType() == activityType
end

local function CheckQuests(obj)
	local activityType = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and LFG_ACTIVITY_DUNGEON or LFG_ACTIVITY_MASTER_DUNGEON
	return obj.quest and obj.node.data:GetActivityType() == activityType
end

local function AddPledge(control, data)
	local function AddIcon()
		local activityId=data.id
		local pledgeText=""

		for npc=1,3 do
			local pledgeId = todayPledges[npc]
			if pledgeId and DungeonActivityData[activityId].p==pledgeId then
				local pledgeName = PledgeQuestName[pledgeId]:lower()
				local questCompleted=pledgeQuests[pledgeName]
				-- Save if it needs to be checked
				control.pledge=questCompleted==false
				if questCompleted==true then
					-- In Journal and completed
					pledgeText="/esoui/art/lfg/lfg_indexicon_dungeon_up.dds"
				elseif questCompleted==false then
					-- In Journal and no completed
					pledgeText="/esoui/art/lfg/lfg_indexicon_dungeon_down.dds" -- Ok
				else
					-- TODO: Differentiate between done and not in journal, and not done and not in journal
					-- No in journal quest
					pledgeText="/esoui/art/lfg/lfg_indexicon_dungeon_over.dds"
				end
				pledgeText = finderActivityExtender:FormatTexture(pledgeText)
				break
			end
		end
		return finderActivityExtender:AddLabel(pledgeText, control:GetName().."p", control, 400)
	end

	local function ChangeColor()
		local activityId=data.id
		local text = control.text:GetText()
		for npc=1,3 do
			local pledgeId = todayPledges[npc]
			if pledgeId and DungeonActivityData[activityId].p==pledgeId then
				local pledgeName = PledgeQuestName[pledgeId]:lower()
				local questCompleted=pledgeQuests[pledgeName]
				-- Save if it needs to be checked
				control.pledge=questCompleted==false
				if questCompleted==true then
					-- In Journal and completed
					text="|c32CD32"..text.."|r"
				elseif questCompleted==false then
					-- In Journal and no completed
					text="|cFFD700"..text.."|r"
				else
					-- TODO: Differentiate between done and not in journal, and not done and not in journal
					-- No in journal quest
					text="|c00CED1"..text.."|r"
				end
				break
			end
		end
		control.text:SetText(text)
	end

	local savedVars = GAFE.SavedVars

	local icon = AddIcon()
	icon:SetHidden(not savedVars.dungeons.dailyPledgeMarker.isIcon)

	if not savedVars.dungeons.dailyPledgeMarker.isIcon then
		ChangeColor()
	end
end

local function RefreshControls()
	local autoMarkPledges = GAFE.SavedVars.dungeons.autoMarkPledges

	checkQuestsButton:SetState(haveQuests and BSTATE_NORMAL or BSTATE_DISABLED)
	checkPledgesButton:SetState(havePledge and BSTATE_NORMAL or BSTATE_DISABLED)
	checkPledgesButton:SetHidden(autoMarkPledges)
end

local function OnShown()
	UpdateLocals()
	GAFE.CallLater(GAFE.name.."_ExtendDungeonActivity", 200, function()
		local savedVars = GAFE.SavedVars
		RefreshControls()
		finderActivityExtender:AutoCollapse()
		if savedVars.dungeons.autoMarkPledges then
			finderActivityExtender:CheckFunc(CheckPledges)()
		end
	end)
end

local function FastTravelToAllianceCity(nodeIndex, allianceId, parent)
	if nodeIndex then
        local knownNode, name = GetFastTravelNodeInfo(nodeIndex)
        local size = 30
		local texture, position
		if allianceId == AllianceId.Aldmeri then
			texture = "/esoui/art/ava/ava_allianceflag_aldmeri.dds"
			position = 0
		elseif allianceId == AllianceId.Daggerfall then
			texture = "/esoui/art/ava/ava_allianceflag_daggerfall.dds"
			position = size * 2
		elseif allianceId == AllianceId.Ebonheart then
			texture = "/esoui/art/ava/ava_allianceflag_ebonheart.dds"
			position = size * 4
		end

		GAFE.UI.Texture(parent:GetName().."Label"..allianceId, parent, {size,size*2}, {TOPLEFT,parent,TOPLEFT,position, -40}, texture)
        local button = GAFE.UI.Button(parent:GetName().."Button"..allianceId, parent, {size*1.2,size*1.2}, {TOPLEFT,parent,TOPLEFT,position+size-10, -40}, nil, function() finderActivityExtender:FastTravel(nodeIndex, name) end, knownNode)
        if knownNode then
            button:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_complete.dds")
        else
            button:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_incomplete.dds")
        end
    end
end

function GAFE.DungeonFinder.Init()
	-- Panel buttons
	local parent = ZO_DungeonFinder_Keyboard
	if parent then
		local w = parent:GetWidth()
		local dims = {200,28}
		local autoMarkPledges = GAFE.SavedVars.dungeons.autoMarkPledges

		FastTravelToAllianceCity(214, AllianceId.Aldmeri, parent)
		FastTravelToAllianceCity(56, AllianceId.Daggerfall, parent)
		FastTravelToAllianceCity(28, AllianceId.Ebonheart, parent)

		checkQuestsButton = GAFE.UI.ZOButton("GAFE_QuestsCheck", parent, dims, {BOTTOM,parent,BOTTOM,w/3,0}, GAFE.Loc("CheckMissingQuests"), finderActivityExtender:CheckFunc(CheckQuests), haveQuests)
		checkPledgesButton = GAFE.UI.ZOButton("GAFE_PledgesCheck", parent, dims, {BOTTOM,parent,BOTTOM,-w/3,0}, GAFE.Loc("CheckActivePledges"), finderActivityExtender:CheckFunc(CheckPledges), havePledge, nil, autoMarkPledges)

		if ZO_DungeonFinder_KeyboardQueueButton then
			ZO_DungeonFinder_KeyboardQueueButton:ClearAnchors()
			ZO_DungeonFinder_KeyboardQueueButton:SetAnchor(BOTTOM,parent,BOTTOM,0,0)
			ZO_DungeonFinder_KeyboardQueueButton:SetDrawTier(2)
		end
	end

	-- Entry extensions
	local treeEntry	= DUNGEON_FINDER_KEYBOARD.navigationTree.templateInfo.ZO_ActivityFinderTemplateNavigationEntry_Keyboard
	local baseEntrySetupFunction = treeEntry.setupFunction
	treeEntry.setupFunction = function(node, control, data, open)
		baseEntrySetupFunction(node, control, data, open)

		local activityId=data.id
		if DungeonActivityData[activityId] then
			local debug = GetDisplayName() == "@Panicida"

			-- Teleport
			finderActivityExtender:AddTeleport(DungeonActivityData[activityId].node, control)

			-- Pledge
			AddPledge(control, data)

			-- Quest (skill point)
			finderActivityExtender:AddQuest(DungeonActivityData[activityId].q, control:GetName().."q", control, "/esoui/art/icons/achievements_indexicon_quests_up.dds", 420, debug)
			control.quest = GetCompletedQuestInfo(DungeonActivityData[activityId].q) == "" and true or false
			haveQuests = haveQuests or control.quest

			-- General Vanquisher (normal) / Conqueror (veteran)
			finderActivityExtender:AddAchievement(DungeonActivityData[activityId].id, control:GetName().."id", control, "/esoui/art/announcewindow/announcement_icon_up.dds", 440, debug)

			-- Death challenge (hard mode)
			finderActivityExtender:AddAchievement(DungeonActivityData[activityId].hm, control:GetName().."hm", control, "/esoui/art/unitframes/target_veteranrank_icon.dds", 460, debug)

			-- Speed challenge
			finderActivityExtender:AddAchievement(DungeonActivityData[activityId].tt, control:GetName().."tt", control, "/esoui/art/ava/overview_icon_underdog_score.dds", 480, debug)

			-- Survivor challenge (no death)
			finderActivityExtender:AddAchievement(DungeonActivityData[activityId].nd, control:GetName().."nd", control, "/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds", 500, debug)
		else
			GAFE.UI.Label(control:GetName().."TODO", control, {125,20}, {LEFT,control,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, "TODO:"..activityId)
		end
	end

	ZO_PreHookHandler(ZO_DungeonFinder_KeyboardListSection, 'OnEffectivelyShown', OnShown)
end