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
local day=1
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

	TodayPledges()
	GoalPledges()
	Day()
end

local function CheckPledges(obj)
	return obj.pledge
end

local function CheckQuests(obj)
	return obj.quest
end

local function ExtendDungeonActivity(obj, c, i)
	local activityId=obj.node.data.id
	if DungeonActivityData[activityId] then
		local pledgeText=""
		-- Mark dialy pledges
		for npc=1,3 do
			local pledgeId = todayPledges[npc]
			if pledgeId and DungeonActivityData[activityId].p==pledgeId then
				local pledgeName = PledgeQuestName[pledgeId]:lower()
				local questCompleted=pledgeQuests[pledgeName]
				-- Save if it needs to be checked
				obj.pledge=questCompleted==false
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
		finderActivityExtender:AddLabel(pledgeText, "Pledge"..c..i, obj, 400)

		local debug = GetDisplayName() == "@Panicida"

		-- Quest (skill point)
		finderActivityExtender:AddQuest(DungeonActivityData[activityId].q, "q"..c..i, obj, "/esoui/art/icons/achievements_indexicon_quests_up.dds", 420, debug)

		-- General Vanquisher (normal) / Conqueror (veteran)
		finderActivityExtender:AddAchievement(DungeonActivityData[activityId].id, "id"..c..i, obj, "/esoui/art/announcewindow/announcement_icon_up.dds", 440, debug)

		-- Death challenge (hard mode)
		finderActivityExtender:AddAchievement(DungeonActivityData[activityId].hm, "hm"..c..i, obj, "/esoui/art/unitframes/target_veteranrank_icon.dds", 460, debug)

		-- Speed challenge
		finderActivityExtender:AddAchievement(DungeonActivityData[activityId].tt, "tt"..c..i, obj, "/esoui/art/ava/overview_icon_underdog_score.dds", 480, debug)

		-- Survivor challenge (no death)
		finderActivityExtender:AddAchievement(DungeonActivityData[activityId].nd, "nd"..c..i, obj, "/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds", 500, debug)

		-- Quest
		obj.quest = GetCompletedQuestInfo(DungeonActivityData[activityId].q) == "" and true or false
		haveQuests = haveQuests or obj.quest
	else
		GAFE.UI.Label(GAFE.name.."_DungeonInfo_Todo"..c..i, obj, {125,20}, {LEFT,obj,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, "TODO:"..activityId)
	end
end

local function RefreshControls()
	local autoMarkPledges = GAFE.SavedVars.dungeons.autoMarkPledges

	checkQuestsButton:SetState(haveQuests and BSTATE_NORMAL or BSTATE_DISABLED)
	checkPledgesButton:SetState(havePledge and BSTATE_NORMAL or BSTATE_DISABLED)
	checkPledgesButton:SetHidden(autoMarkPledges)
end

local function DisableControls()
	checkQuestsButton:SetState(BSTATE_DISABLED)
	checkPledgesButton:SetState(BSTATE_DISABLED)
end

local function OnShown()
	UpdateLocals()
	GAFE.CallLater("ExtendDungeonActivity", 200, function()
		finderActivityExtender:ExtendFunc(ExtendDungeonActivity, RefreshControls)()
		local autoMarkPledges = GAFE.SavedVars.dungeons.autoMarkPledges
		if autoMarkPledges then
			finderActivityExtender:CheckFunc(CheckPledges)()
		end
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


	ZO_PreHookHandler(ZO_DungeonFinder_KeyboardListSection, 'OnEffectivelyShown', OnShown)
	ZO_PreHookHandler(ZO_DungeonFinder_KeyboardListSection, 'OnEffectivelyHidden', function()
		DisableControls()
	end)
end