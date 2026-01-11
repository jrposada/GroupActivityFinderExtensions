local GAFE = GroupActivityFinderExtensions
local LQD = LibQuestData
local LUP = LibUndauntedPledges

GAFE_QUEST_AUTOMATION = {
  dialyNpcName = {},
  craftingWritNpcName = {}
}

local function contains(data, value)
  for _, item in ipairs(data) do
    if item == value then
      return true
    end
  end

  return false
end

--- Checks if an NPC is one of the three Undaunted pledge givers.
--- @param npcName string The NPC name to check
--- @return boolean isPledgeGiver True if the NPC is a pledge giver
local function IsPledgeGiver(npcName)
  return npcName == LUP.GetPledgeGiverName(LUP.BASE1)
      or npcName == LUP.GetPledgeGiverName(LUP.BASE2)
      or npcName == LUP.GetPledgeGiverName(LUP.DLC1)
end

--- Check if quest id is one of the crafting writs. Only checks for one of each type.
--- Used to get the quest giver name.
--- @param questId number The quest ID to check
--- @return boolean isCraftingWrit True if the quest is a crafting writ
local function IsCraftingWrit(questId)
  return questId == 5394 or questId == 5415
end

function GAFE_QUEST_AUTOMATION.Init()
  local allZones = LibQuestData_GetAllZones()
  for _, zone in pairs(allZones) do
    for _, questPinData in ipairs(zone) do
      local questId = questPinData[LQD.quest_map_pin_index.quest_id]
      local questRepeat = LQD:get_quest_repeat(questId)

      if questRepeat == QUEST_REPEAT_DAILY or questRepeat == QUEST_REPEAT_REPEATABLE then
        local npcName = LQD:get_quest_giver(
          questPinData[LQD.quest_map_pin_index.quest_giver],
          GAFE.lang
        )
        local isCraftingWrit = IsCraftingWrit(questId)

        if isCraftingWrit and not contains(GAFE_QUEST_AUTOMATION.craftingWritNpcName, npcName) then
          table.insert(GAFE_QUEST_AUTOMATION.craftingWritNpcName, npcName)
        elseif not contains(GAFE_QUEST_AUTOMATION.dialyNpcName, npcName) then
          table.insert(GAFE_QUEST_AUTOMATION.dialyNpcName, npcName)
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
  local questCompletedEventName, questCompleted = GAFE.name .. "_QuestCompleted",
      false

  local function HandleQuestOffered()
    if questOffered then
      EVENT_MANAGER:UnregisterForEvent(questOfferedEventName, EVENT_QUEST_OFFERED)
    end

    questOffered = true
    AcceptOfferedQuest()
  end

  local function HandleQuestCompleted()
    EVENT_MANAGER:UnregisterForEvent(questCompletedEventName,
      EVENT_QUEST_COMPLETE_DIALOG)

    questCompleted = true
    CompleteQuest()
  end

  local function HandleConversationUpdated(_, conversationBodyText, optionCount)
    EVENT_MANAGER:UnregisterForEvent(conversationUpdatedEventName,
      EVENT_QUEST_OFFERED)

    if optionCount ~= 0 then
      for optionIndex = 1, optionCount + 1 do
        local optionString, optionType = GetChatterOption(optionIndex)
        if optionType == CHATTER_TALK_CHOICE then
          questCompleted = false
          EVENT_MANAGER:RegisterForEvent(questCompletedEventName,
            EVENT_QUEST_COMPLETE_DIALOG,
            HandleQuestCompleted)
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

    if contains(GAFE_QUEST_AUTOMATION.dialyNpcName, npcName) and not contains(GAFE_QUEST_AUTOMATION.craftingWritNpcName, npcName) then
      if optionCount ~= 0 then
        for optionIndex = 1, optionCount + 1 do
          local optionString, optionType = GetChatterOption(optionIndex)

          if optionType == CHATTER_START_NEW_QUEST_BESTOWAL then
            questOffered = false
            EVENT_MANAGER:RegisterForEvent(questOfferedEventName,
              EVENT_QUEST_OFFERED, HandleQuestOffered)
            SelectChatterOption(optionIndex)
          elseif optionType == CHATTER_START_TALK and IsPledgeGiver(npcName) then
            -- For some reason pledges EVENT_QUEST_COMPLETE_DIALOG is hidden behind one chatter start.
            questCompleted = false
            EVENT_MANAGER:RegisterForEvent(conversationUpdatedEventName,
              EVENT_CONVERSATION_UPDATED,
              HandleConversationUpdated)
            SelectChatterOption(optionIndex)
          elseif optionType == CHATTER_START_COMPLETE_QUEST then
            questCompleted = false
            EVENT_MANAGER:RegisterForEvent(questCompletedEventName,
              EVENT_QUEST_COMPLETE_DIALOG,
              HandleQuestCompleted)
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
    EVENT_MANAGER:UnregisterForEvent(questCompletedEventName,
      EVENT_QUEST_COMPLETE_DIALOG)
    EVENT_MANAGER:UnregisterForEvent(conversationUpdatedEventName,
      EVENT_QUEST_OFFERED)
  end

  GAFE.SavedVars.dungeons.handlePledgeQuest = enable
end
