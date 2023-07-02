local GAFE = GroupActivityFinderExtensions
local LQD = LibQuestData
local LQD_Internal = _G["LibQuestData_Internal"]

GAFE_DIALY_NPC_NAME = {}
GAFE_PLEDGE_NPC_NAME = {}
GAFE_CRAFTING_WRITS_NPC_NAME = {}

GAFE_QUEST_AUTOMATION = {}

local function contains(data, value)
    for _, item in ipairs(data) do
        if item == value then
            return true
        end
    end

    return false
end

--- Helper to get if pledge id is from a pledge. Only checks for one quest per character name.
--- Used to get the quest giver name.
---@param questId any
---@return boolean
local function IsPledge(questId)
    return questId == GAFE_PLEDGE_ID.EldenHollowII or questId == GAFE_PLEDGE_ID.Volenfell or questId == GAFE_PLEDGE_ID.ImperialCityPrison
end

--- Check if quest id is one of the crafting writs. Only checks for one of each type.
--- Used to get the quest giver name.
---@param questId any
---@return boolean
local function IsCraftingWrit(questId)
    return questId == 5394 or questId == 5415
end

function GAFE_QUEST_AUTOMATION.Init()
    for _, zone in pairs(LQD_Internal.quest_locations) do
        for _, questPinData in ipairs(zone) do
            local questId = questPinData[LQD.quest_map_pin_index.quest_id]
            local questRepeat = LQD:get_quest_repeat(questId)

            if questRepeat == LQD.quest_data_repeat.quest_repeat_daily or questRepeat == LQD.quest_data_repeat.quest_repeat_repeatable then
                local npcName = LQD:get_quest_giver(questPinData[LQD.quest_map_pin_index.quest_giver], GAFE.lang)
                local isPledge = IsPledge(questId)
                local isCraftingWrit = IsCraftingWrit(questId)

                if isPledge and not contains(GAFE_PLEDGE_NPC_NAME, npcName) then
                    table.insert(GAFE_PLEDGE_NPC_NAME, npcName)
                elseif isCraftingWrit and not contains(GAFE_CRAFTING_WRITS_NPC_NAME, npcName) then
                    table.insert(GAFE_CRAFTING_WRITS_NPC_NAME, npcName)
                elseif not contains(GAFE_DIALY_NPC_NAME, npcName) then
                    table.insert(GAFE_DIALY_NPC_NAME, npcName)
                end
            end
        end
    end

    GAFE_QUEST_AUTOMATION.AutomaticallyHandleQuests(
        GAFE.SavedVars.dungeons.handlePledgeQuest
    )
end

function GAFE_QUEST_AUTOMATION.AutomaticallyHandleQuests(enable)
    local questOfferedEventName, questOffered = GAFE.name .. "_QuestOffered", false
    local conversationUpdatedEventName = GAFE.name .. "_ConverationUpdated"
    local questCompletedEventName, questCompleted = GAFE.name .. "_QuestCompleted", false

    local function HandleQuestOffered()
        if questOffered then
            EVENT_MANAGER:UnregisterForEvent(questOfferedEventName, EVENT_QUEST_OFFERED)
        end

        questOffered = true
        AcceptOfferedQuest()
    end

    local function HandleQuestCompleted()
        EVENT_MANAGER:UnregisterForEvent(questCompletedEventName, EVENT_QUEST_COMPLETE_DIALOG)

        questCompleted = true
        CompleteQuest()
    end

    local function HandleConversationUpdated(_, conversationBodyText, optionCount)
        EVENT_MANAGER:UnregisterForEvent(conversationUpdatedEventName, EVENT_QUEST_OFFERED)

        if optionCount ~= 0 then
            for optionIndex = 1, optionCount + 1 do
                local optionString, optionType = GetChatterOption(optionIndex)
                if optionType == CHATTER_TALK_CHOICE then
                    questCompleted = false
                    EVENT_MANAGER:RegisterForEvent(questCompletedEventName, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleted)
                    SelectChatterOption(optionIndex)
                end
            end
        end
    end

    local function HandleChatterBegin(_, optionCount, _debugSource_)
        local npcName = GetUnitName("interact")

        if questOffered or questCompleted then
            EndInteraction(INTERACTION_CONVERSATION)
        end

        if contains(GAFE_DIALY_NPC_NAME, npcName) and not contains(GAFE_CRAFTING_WRITS_NPC_NAME, npcName) then
            if optionCount ~= 0 then
                for optionIndex = 1, optionCount + 1 do
                    local optionString, optionType = GetChatterOption(optionIndex)

                    if optionType == CHATTER_START_NEW_QUEST_BESTOWAL then
                        questOffered = false
                        EVENT_MANAGER:RegisterForEvent(questOfferedEventName, EVENT_QUEST_OFFERED, HandleQuestOffered)
                        SelectChatterOption(optionIndex)
                    elseif optionType == CHATTER_START_TALK and contains(GAFE_PLEDGE_NPC_NAME, npcName) then
                        -- For some reason pledges EVENT_QUEST_COMPLETE_DIALOG is hidden behind one chatter start.
                        questCompleted = false
                        EVENT_MANAGER:RegisterForEvent(conversationUpdatedEventName, EVENT_CONVERSATION_UPDATED, HandleConversationUpdated)
                        SelectChatterOption(optionIndex)
                    elseif optionType == CHATTER_START_COMPLETE_QUEST then
                        questCompleted = false
                        EVENT_MANAGER:RegisterForEvent(questCompletedEventName, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleted)
                        SelectChatterOption(optionIndex)
                    end
                end
            end
        end
    end

    local function HandleChatterEnd()
        questOffered = false
        questCompleted = false
    end

    local chatterBeginName = GAFE.name .. "_QuestAutomation_ChatterBegin"
    local chatterEndName = GAFE.name .. "_QuestAutomation_ChatterEnd"

    if enable then
        EVENT_MANAGER:RegisterForEvent(
            chatterBeginName,
            EVENT_CHATTER_BEGIN,
            HandleChatterBegin
        )
        EVENT_MANAGER:RegisterForEvent(
            chatterEndName,
            EVENT_CHATTER_END,
            HandleChatterEnd
        )
    else
        EVENT_MANAGER:UnregisterForEvent(chatterBeginName, EVENT_CHATTER_BEGIN)
        EVENT_MANAGER:UnregisterForEvent(chatterBeginName, EVENT_CHATTER_END)
        EVENT_MANAGER:UnregisterForEvent(questOfferedEventName, EVENT_QUEST_OFFERED)
        EVENT_MANAGER:UnregisterForEvent(questCompletedEventName, EVENT_QUEST_COMPLETE_DIALOG)
        EVENT_MANAGER:UnregisterForEvent(conversationUpdatedEventName, EVENT_QUEST_OFFERED)
    end

    GAFE.SavedVars.dungeons.handlePledgeQuest = enable
end

