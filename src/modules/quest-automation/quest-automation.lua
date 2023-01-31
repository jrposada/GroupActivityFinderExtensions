local GAFE = GroupActivityFinderExtensions

GAFE_QUEST_AUTOMATION = {}

function GAFE_QUEST_AUTOMATION.Init()
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

        if GAFE_PLEDGE_NPC_NAME[npcName] or GAFE_DIALY_NPC_NAME[npcName] then
            if optionCount ~= 0 then
                for optionIndex = 1, optionCount + 1 do
                    local optionString, optionType = GetChatterOption(optionIndex)

                    if optionType == CHATTER_START_NEW_QUEST_BESTOWAL then
                        questOffered = false
                        EVENT_MANAGER:RegisterForEvent(questOfferedEventName, EVENT_QUEST_OFFERED, HandleQuestOffered)
                        SelectChatterOption(optionIndex)
                    elseif optionType == CHATTER_START_TALK and not GAFE_DIALY_NPC_NAME[npcName] then
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

