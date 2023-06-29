local GAFE = GroupActivityFinderExtensions
local LQD = LibQuestData
local LQD_Internal = _G["LibQuestData_Internal"]


GAFE_DIALY_NPC_NAME = {}

GAFE_QUEST_AUTOMATION = {}

local function contains(data, value)
    for _, item in ipairs(data) do
        if item == value then
            return true
        end
    end

    return false
end

function GAFE_QUEST_AUTOMATION.Init()
    for _, zone in pairs(LQD_Internal.quest_locations) do
        for _, questPinData in ipairs(zone) do
            local questRepeat = LQD:get_quest_repeat(questPinData[LQD.quest_map_pin_index.quest_id])

            if questRepeat == LQD.quest_data_repeat.quest_repeat_daily or questRepeat == LQD.quest_data_repeat.quest_repeat_repeatable then
                local npcName = LQD:get_quest_giver(questPinData[LQD.quest_map_pin_index.quest_giver], GAFE.lang)
                -- todo check for duplicates.
                if not contains(GAFE_DIALY_NPC_NAME, npcName) then
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
            questOffered = false
            questCompleted = false
            EndInteraction(INTERACTION_CONVERSATION)
        end

        -- FIXME infinite loop with new GAFE_DIALY_NPC_NAME var
        if contains(GAFE_DIALY_NPC_NAME, npcName) then
            if optionCount ~= 0 then
                for optionIndex = 1, optionCount + 1 do
                    local optionString, optionType = GetChatterOption(optionIndex)

                    if optionType == CHATTER_START_NEW_QUEST_BESTOWAL then
                        GAFE.LogLater("juan")
                        questOffered = false
                        EVENT_MANAGER:RegisterForEvent(questOfferedEventName, EVENT_QUEST_OFFERED, HandleQuestOffered)
                        SelectChatterOption(optionIndex)
                    elseif optionType == CHATTER_START_TALK and GAFE_PLEDGE_NPC_NAME[npcName] then
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

    if enable then
        EVENT_MANAGER:RegisterForEvent(
            GAFE.name .. "_QuestAutomation_ChatterBegin",
            EVENT_CHATTER_BEGIN,
            HandleChatterBegin
        )
    else
        EVENT_MANAGER:UnregisterForEvent(GAFE.name .. "_QuestAutomation_ChatterBegin")
    end

    GAFE.SavedVars.dungeons.handlePledgeQuest = enable
end

