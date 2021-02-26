local GAFE = GroupActivityFinderExtensions

local PledgeQuestName = GAFE.DungeonPledgeQuestName
local PledgeList = GAFE.DungeonPledgeList
local DungeonActivityData = GAFE.DungeonActivityData

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
		finderActivityExtender:AddLabel(pledgeText, control:GetName().."p", control, 400)
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
	if savedVars.dungeons.dailyPledgeMarker.isIcon then
		AddIcon()
	else
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
		RefreshControls()
		finderActivityExtender:AutoCollapse()
	end)
end

function GAFE.DungeonFinder.Init()
	-- Panel buttons
	local parent = ZO_DungeonFinder_Keyboard
	if parent then
		local w = parent:GetWidth()
		local dims = {200,28}
		local autoMarkPledges = GAFE.SavedVars.dungeons.autoMarkPledges

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