local GAFE = GroupActivityFinderExtensions
local dungeonData = GAFE_DUNGEONS_ACTIVITY_DATA

local extender = GAFE_ActivityFinderExtender:New()

local characterId = GetCurrentCharacterId()

local todayPledges = {
    day = nil
}

--- Updates local todayPledges variable with GAFE_PLEDGE_ID of today's pledges to true.
--- It will also reset done pledges of the day.
local function UpdateTodayPledges()
    todayPledges = {
        day = nil
    }

    todayPledges.day = math.floor(GetDiffBetweenTimeStamps(GetTimeStamp(), 1517464800) / 86400) -- 86400 = 1 day

    for npc = 1, 3 do
        local dpList = GAFE_PLEDGE_LIST[npc]
        local n = 1 + (todayPledges.day + dpList.shift) % #dpList
        todayPledges[dpList[n]] = true
    end

    local savedVars = GAFE.SavedVars
    if savedVars.dungeons.donePledges.day ~= todayPledges.day then
        savedVars.dungeons.donePledges = {}
        savedVars.dungeons.donePledges.day = todayPledges.day
    end
    if savedVars.dungeons.donePledges[characterId] == nil then
        savedVars.dungeons.donePledges[characterId] = {}
    end
end

local function QuestNameToPledgeId(_questName_)
    local questName = _questName_
    -- FIXME: broken in french
    -- Remove weird white spaces and other special characters.
    local cleanQuestName = string.format("%s", questName:gsub(".*:%s*", ""):gsub(" ", " "):lower())
    local pledgeId = nil
    for id, pledgeName in pairs(GAFE_DUNGEON_PLEDGE_QUEST_NAME) do
        if string.match(cleanQuestName, pledgeName:lower()) then
            pledgeId = id
        end
    end

    return pledgeId
end

local pledgesInJournal = {}

--- Updates local pledgesInJournal variable with the GAFE_PLEDGE_ID of pledges in journal and whether they have been completed or not.
local function UpdatePledgesInJournal()
    pledgesInJournal = {}

    for i = 1, MAX_JOURNAL_QUESTS do
        local questName, _, _, stepType, _, completed, _, _, _, questType, instanceType = GetJournalQuestInfo(i)
        if questName and questName ~= "" and not completed and questType == QUEST_TYPE_UNDAUNTED_PLEDGE and instanceType == INSTANCE_TYPE_GROUP then

            local pledgeId = QuestNameToPledgeId(questName)

            if pledgeId then
                pledgesInJournal[pledgeId] = stepType ~= QUEST_STEP_TYPE_AND
            else
                GAFE.LogLater("Group & Activity Finder Extensions has encounter an unknown pledge quest name: " .. questName)
            end
        end
    end
end

local function AddPledge(_pledgeId_, _control_)
    local pledgeId, control = _pledgeId_, _control_

    local donePledges = GAFE.SavedVars.dungeons.donePledges[characterId]
    local text = control.text:GetText()
    if pledgesInJournal[pledgeId] or donePledges[pledgeId] then
        -- In Journal and completed or done and not in journal
        text = "|c32CD32" .. text .. "|r" -- green
    elseif pledgesInJournal[pledgeId] == false then
        -- In Journal and no completed
        text = "|cFFD700" .. text .. "|r" -- gold
    elseif todayPledges[pledgeId] then
        -- Not done and not in journal
        text = "|c00CED1" .. text .. "|r" -- blue
    end
    control.text:SetText(text)

    control.gafePledge = pledgesInJournal[pledgeId] == false
end

local function CheckPledges()
    local function checkFunc(_obj_)
        local obj = _obj_

        return obj.gafePledge and obj.node.data:GetActivityType() == extender.dungeonDifficulty
    end

    extender:RefreshDungeonDifficulty()
    extender:CheckAllWhere(checkFunc)
end

local function OnQuestAdded(_, _journalIndex_, _questName_, _objectiveName_)
    UpdateTodayPledges()
    UpdatePledgesInJournal()

    DUNGEON_FINDER_KEYBOARD.navigationTree:Reset()
end

local function OnQuestRemoved(_, _isCompleted_, _journalIndex_, _questName_, _zoneIndex_, _poiIndex_, _questID_)
    local isCompleted, questName = _isCompleted_, _questName_

    local pledgeId = QuestNameToPledgeId(questName)

    if isCompleted and pledgeId then
        local donePledges = GAFE.SavedVars.dungeons.donePledges
        donePledges[characterId][pledgeId] = true
    end

    UpdateTodayPledges()
    UpdatePledgesInJournal()

    DUNGEON_FINDER_KEYBOARD.navigationTree:Reset()
end

GAFE_DUNGEON_EXTENSIONS = {}

function GAFE_DUNGEON_EXTENSIONS.Init()
    local treeEntry = DUNGEON_FINDER_KEYBOARD.navigationTree.templateInfo.ZO_ActivityFinderTemplateNavigationEntry_Keyboard

    local keybindStripGroup = {
        {
            alignment = KEYBIND_STRIP_ALIGN_CENTER,
            name = GAFE.Loc("CheckActivePledges"),
            keybind = "UI_SHORTCUT_SECONDARY",
            callback = function() CheckPledges() end,
            visible = function()
                local donePledges = GAFE.SavedVars.dungeons.donePledges[characterId];

                for _, pledgeId in ipairs(todayPledges) do
                    if not GAFE.ContainsKey(donePledges, pledgeId) then
                        return false
                    end
                end

                return true
            end
        },
    }

    local function customExtensions(node, control, data, open)
        local activityId = data.id
        local activityData = dungeonData[activityId]
        if activityData then
            -- Pledge
            AddPledge(activityData.p, control)
        end
    end

    local function OnShown()
        if GAFE.SavedVars.dungeons.autoMarkPledges then
            CheckPledges()
        end
    end

    local function OnActivityFinderStatusUpdate(_, status)
        -- Check 1 second later so IsActivityEligibleForDailyReward is ready.
        zo_callLater(function()
            local isRewardAvailable = extender.GetTimeUntilNextReward(extender.characterId, extender.rewardsVars) <= 0
            -- There are several dungeon activities but so far they all share the reward.
            local isRewardAvailableByZos = IsActivityEligibleForDailyReward(LFG_ACTIVITY_DUNGEON)

            if status == ACTIVITY_FINDER_STATUS_COMPLETE and isRewardAvailable and not isRewardAvailableByZos then
                extender.rewardsVars.randomRewards[extender.characterId] = GetTimeStamp()
            end
        end, 1000)
    end

    GAFE_DUNGEON_EXTENSIONS.AutomaticallyHandlePledgeQuests(
        GAFE.SavedVars.dungeons.handlePledgeQuest
    )

    extender:Initialize("ZO_Dungeon", dungeonData, treeEntry, customExtensions, GAFE.SavedVars.dungeons, keybindStripGroup, OnShown)

    EVENT_MANAGER:RegisterForEvent(
        GAFE.name .. "_DungonExtension_PlayerReady",
        EVENT_PLAYER_ACTIVATED,
        function()
            UpdateTodayPledges()
            UpdatePledgesInJournal()
        end
    )
    EVENT_MANAGER:RegisterForEvent(GAFE.name .. "_DungonExtension_QuestAdded", EVENT_QUEST_ADDED, OnQuestAdded)
    EVENT_MANAGER:RegisterForEvent(GAFE.name .. "_DungonExtension_QuestRemoved", EVENT_QUEST_REMOVED, OnQuestRemoved)
    EVENT_MANAGER:RegisterForEvent(extender.root .. "Activity_Update", EVENT_ACTIVITY_FINDER_STATUS_UPDATE, OnActivityFinderStatusUpdate)
end

function GAFE_DUNGEON_EXTENSIONS.AutomaticallyHandlePledgeQuests(enable)
    local questOfferedEventName, questOffered = GAFE.name .. "_QuestOffered", false

    local function HandleQuestOffered()
        if questOffered then
            EVENT_MANAGER:UnregisterForEvent(questOfferedEventName, EVENT_QUEST_OFFERED)
        end

        questOffered = true
        AcceptOfferedQuest()
    end

    local function HandleChatterBegin(_, _optionCount_, _debugSource_)
        local optionCount = _optionCount_

        local npcName = GetUnitName("interact")

        if questOffered then
            questOffered = false
            EndInteraction(INTERACTION_CONVERSATION)
        end

        if GAFE_PLEDGE_NPC_NAME[npcName] then
            if optionCount ~= 0 then
                for optionIndex = 1, optionCount do
                    local optionString, optionType = GetChatterOption(optionIndex)

                    if optionType == CHATTER_START_NEW_QUEST_BESTOWAL
                        or optionType == CHATTER_START_COMPLETE_QUEST
                    then
                        questOffered = false
                        EVENT_MANAGER:RegisterForEvent(questOfferedEventName, EVENT_QUEST_OFFERED, HandleQuestOffered)
                        SelectChatterOption(optionIndex)
                    end
                end
            end
        end
    end

    if enable then
        EVENT_MANAGER:RegisterForEvent(
            GAFE.name .. "_DungonExtension_PledgeChatter",
            EVENT_CHATTER_BEGIN,
            HandleChatterBegin
        )
    else
        EVENT_MANAGER:UnregisterForEvent(GAFE.name .. "_DungonExtension_PledgeChatter")
    end

    GAFE.SavedVars.dungeons.handlePledgeQuest = enable
end
