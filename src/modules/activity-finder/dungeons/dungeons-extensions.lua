local GAFE = GroupActivityFinderExtensions
local dungeonData = GAFE_DUNGEONS_ACTIVITY_DATA
local LQD = LibQuestData

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

    todayPledges.day = GAFE.GetDay()

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
    local pledgeId = nil
    for _, id in pairs(GAFE_PLEDGE_ID) do
        local pledgeName = LQD:get_quest_name(id, GAFE.lang)
        if questName == pledgeName then
            pledgeId = id
            break
        end
    end

    return pledgeId
end

local pledgesInJournal = {}

--- Updates local pledgesInJournal variable with the GAFE_PLEDGE_ID of pledges in journal and whether they have been completed or not.
local function UpdatePledgesInJournal()
    pledgesInJournal = GAFE_DUNGEON_EXTENSIONS.GetPledgesInJournal()
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

local function QueueForPledges()
    local function checkFunc(_obj_)
        local obj = _obj_

        return obj.gafePledge and obj.node.data:GetActivityType() == extender.dungeonDifficulty
    end

    extender:RefreshDungeonDifficulty()
    extender:CheckAllWhere(checkFunc)

    ZO_ACTIVITY_FINDER_ROOT_MANAGER:StartSearch()
end

local function QueueForRandomDungeon()
    if IsCurrentlySearchingForGroup() then
        return
    end
    extender:RefreshDungeonDifficulty()

    ClearGroupFinderSearch()
    local activitySetId = GetActivitySetIdByTypeAndIndex(extender.dungeonDifficulty, 1)
    AddActivityFinderSetSearchEntry(activitySetId)

    local result = StartGroupFinderSearch()
    if result ~= ACTIVITY_QUEUE_RESULT_SUCCESS then
        ZO_AlertEvent(EVENT_ACTIVITY_QUEUE_RESULT, result)
    else
        GAFE.LogLater(zo_strformat(GAFE.Loc("QueueForActivity"),
            extender.dungeonDifficulty == LFG_ACTIVITY_DUNGEON
            and GetString(SI_DUNGEONDIFFICULTY1)
            or GetString(SI_DUNGEONDIFFICULTY2),
            GetString(SI_GROUPFINDERCATEGORY_SINGLESELECTDEFAULT0)
        )) -- TODO: translate
    end
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
    local treeEntry = DUNGEON_FINDER_KEYBOARD.navigationTree.templateInfo.
    ZO_ActivityFinderTemplateNavigationEntry_Keyboard

    local keybindStripGroup = {
        -- Active pledges
        {
            alignment = KEYBIND_STRIP_ALIGN_CENTER,
            name = GAFE.Loc("CheckActivePledges"),
            keybind = "UI_SHORTCUT_PRIMARY",
            callback = function() QueueForPledges() end,
            visible = function()
                if IsCurrentlySearchingForGroup() then
                    return false
                end

                local donePledges = GAFE.SavedVars.dungeons.donePledges[characterId];

                for _, pledgeId in ipairs(todayPledges) do
                    if not GAFE.ContainsKey(donePledges, pledgeId) then
                        return false
                    end
                end

                return true
            end
        },
        -- Missing quests
        {
            alignment = KEYBIND_STRIP_ALIGN_CENTER,
            name = GAFE.Loc("CheckMissingQuests"),
            keybind = "UI_SHORTCUT_SECONDARY",
            callback = function() extender:QueueForMissingQuests() end,
            enabled = true, -- TODO:
            visible = function() return not IsCurrentlySearchingForGroup() end
        },
        -- Missing sets
        {
            alignment = KEYBIND_STRIP_ALIGN_CENTER,
            name = GAFE.Loc("CheckMissingSets"),
            keybind = "UI_SHORTCUT_TERTIARY",
            callback = function() extender:QueueForMissingSets() end,
            visible = function()
                if IsCurrentlySearchingForGroup() then
                    return false
                end

                local hasAllSets = true
                for _, activityData in pairs(extender.data) do
                    for _, setId in pairs(activityData.sets) do
                        local setCollectionData = ITEM_SET_COLLECTIONS_DATA_MANAGER:GetItemSetCollectionData(setId)
                        local numUnlockedPieces, numPieces = setCollectionData:GetNumUnlockedPieces(),
                            setCollectionData:GetNumPieces()
                        if numUnlockedPieces ~= numPieces then
                            hasAllSets = false
                            break
                        end
                    end

                    if not hasAllSets then break end
                end
                return not hasAllSets
            end,
        },
        -- Random dungeon
        {
            alignment = KEYBIND_STRIP_ALIGN_CENTER,
            name = GAFE.Loc("CheckRandomDungeon"),
            keybind = "UI_SHORTCUT_QUINARY",
            callback = function() QueueForRandomDungeon() end,
            visible = function() return not IsCurrentlySearchingForGroup() end,
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
            QueueForPledges()
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

    extender:Initialize(
        {
            customExtensions = customExtensions,
            data = dungeonData,
            keybindStripGroup = keybindStripGroup,
            onShown = OnShown,
            rewardsVars = GAFE.SavedVars.dungeons,
            root = "ZO_Dungeon",
            treeEntry = treeEntry,
        })

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
    EVENT_MANAGER:RegisterForEvent(extender.root .. "Activity_Update", EVENT_ACTIVITY_FINDER_STATUS_UPDATE,
        OnActivityFinderStatusUpdate)
end

function GAFE_DUNGEON_EXTENSIONS.GetPledgesInJournal()
    local result = {}

    for i = 1, MAX_JOURNAL_QUESTS do
        local questName, _, _, stepType, _, completed, _, _, _, questType, instanceType = GetJournalQuestInfo(i)
        if questName and questName ~= "" and not completed and questType == QUEST_TYPE_UNDAUNTED_PLEDGE and
            instanceType == INSTANCE_TYPE_GROUP then
            local pledgeId = QuestNameToPledgeId(questName)

            if pledgeId then
                result[pledgeId] = stepType ~= QUEST_STEP_TYPE_AND
            else
                GAFE.LogLater("Group & Activity Finder Extensions has encounter an unknown pledge quest name: " ..
                    questName)
            end
        end
    end

    return result
end
