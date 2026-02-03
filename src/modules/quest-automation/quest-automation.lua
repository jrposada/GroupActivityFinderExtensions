-- ============================================================================
-- Localized Globals
-- ============================================================================
local EVENT_MANAGER = EVENT_MANAGER
local QUEST_REPEAT_DAILY = QUEST_REPEAT_DAILY
local QUEST_REPEAT_REPEATABLE = QUEST_REPEAT_REPEATABLE
local CHATTER_TALK_CHOICE = CHATTER_TALK_CHOICE
local CHATTER_START_NEW_QUEST_BESTOWAL = CHATTER_START_NEW_QUEST_BESTOWAL
local CHATTER_START_TALK = CHATTER_START_TALK
local CHATTER_START_COMPLETE_QUEST = CHATTER_START_COMPLETE_QUEST
local INTERACTION_CONVERSATION = INTERACTION_CONVERSATION
local EVENT_QUEST_OFFERED = EVENT_QUEST_OFFERED
local EVENT_QUEST_COMPLETE_DIALOG = EVENT_QUEST_COMPLETE_DIALOG
local EVENT_CONVERSATION_UPDATED = EVENT_CONVERSATION_UPDATED
local EVENT_CHATTER_BEGIN = EVENT_CHATTER_BEGIN
local EVENT_CHATTER_END = EVENT_CHATTER_END
local GetUnitName = GetUnitName
local GetChatterOption = GetChatterOption
local SelectChatterOption = SelectChatterOption
local AcceptOfferedQuest = AcceptOfferedQuest
local CompleteQuest = CompleteQuest
local EndInteraction = EndInteraction
local HasCompletedQuest = HasCompletedQuest
local ipairs = ipairs
local pairs = pairs
local table_insert = table.insert

local GAFE = GroupActivityFinderExtensions
local LQD = LibQuestData
local LUP = LibUndauntedPledges

-- ============================================================================
-- Constants
-- ============================================================================
-- Crafting writ quest IDs used to identify writ givers
local CRAFTING_WRIT_QUEST_ID_1 = 5394
local CRAFTING_WRIT_QUEST_ID_2 = 5415
-- Prerequisite quest for Undaunted pledges
local UNDAUNTED_PLEDGE_PREREQUISITE_QUEST_ID = 5312

-- Event names
local QUEST_OFFERED_EVENT_NAME = GAFE.name .. "_QuestOffered"
local CONVERSATION_UPDATED_EVENT_NAME = GAFE.name .. "_ConversationUpdated"
local QUEST_COMPLETED_EVENT_NAME = GAFE.name .. "_QuestCompleted"
local CHATTER_BEGIN_EVENT_NAME = GAFE.name .. "_QuestAutomation_ChatterBegin"
local CHATTER_END_EVENT_NAME = GAFE.name .. "_QuestAutomation_ChatterEnd"

-- ============================================================================
-- Module Declaration
-- ============================================================================
local QuestAutomation = {
  dailyNpcName = {},
  craftingWritNpcName = {},
  -- State tracking for automation flow
  questOffered = false,
  questCompleted = false,
  currentNpcName = nil,
  currentOptionCount = 0
}

-- ============================================================================
-- Private Functions
-- ============================================================================

--- Checks if a value exists in a table array.
--- @param data table The array to search
--- @param value any The value to find
--- @return boolean found True if value exists in data
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

--- Checks if quest ID is one of the crafting writs.
--- Only checks for one of each type. Used to get the quest giver name.
--- @param questId number The quest ID to check
--- @return boolean isCraftingWrit True if the quest is a crafting writ
local function IsCraftingWrit(questId)
  return questId == CRAFTING_WRIT_QUEST_ID_1 or
      questId == CRAFTING_WRIT_QUEST_ID_2
end

--- Checks if the player has completed the Undaunted prerequisite quest.
--- @return boolean hasCompletedPrerequisite True if "Taking the Undaunted Pledge" is complete
local function HasCompletedUndauntedPrerequisite()
  return HasCompletedQuest(UNDAUNTED_PLEDGE_PREREQUISITE_QUEST_ID)
end

--- Checks if the given NPC is a daily quest NPC (excluding crafting writs).
--- @param npcName string The NPC name to check
--- @return boolean isDailyNpc True if the NPC gives daily quests
local function IsDailyNpc(npcName)
  return contains(QuestAutomation.dailyNpcName, npcName) and
      not contains(QuestAutomation.craftingWritNpcName, npcName)
end

--- Handler for quest offered event.
local function HandleQuestOffered()
  if QuestAutomation.questOffered then
    EVENT_MANAGER:UnregisterForEvent(QUEST_OFFERED_EVENT_NAME, EVENT_QUEST_OFFERED)
  end

  QuestAutomation.questOffered = true
  AcceptOfferedQuest()
end

--- Handler for quest completed event.
local function HandleQuestCompleted()
  EVENT_MANAGER:UnregisterForEvent(QUEST_COMPLETED_EVENT_NAME, EVENT_QUEST_COMPLETE_DIALOG)

  QuestAutomation.questCompleted = true
  CompleteQuest()
end

--- Handler for conversation updated event.
--- @param _ any Unused event code
--- @param conversationBodyText string The conversation text
--- @param optionCount number Number of dialog options
local function HandleConversationUpdated(_, conversationBodyText, optionCount)
  EVENT_MANAGER:UnregisterForEvent(CONVERSATION_UPDATED_EVENT_NAME, EVENT_QUEST_OFFERED)

  if optionCount ~= 0 then
    for optionIndex = 1, optionCount + 1 do
      local optionString, optionType = GetChatterOption(optionIndex)
      if optionType == CHATTER_TALK_CHOICE then
        QuestAutomation.questCompleted = false
        EVENT_MANAGER:RegisterForEvent(
          QUEST_COMPLETED_EVENT_NAME,
          EVENT_QUEST_COMPLETE_DIALOG,
          HandleQuestCompleted
        )
        SelectChatterOption(optionIndex)
      end
    end
  end
end

--- Processes dialog options and executes appropriate automation.
--- @param optionCount number Number of dialog options
--- @param npcName string The NPC name
local function ProcessDialogOptions(optionCount, npcName)
  if optionCount == 0 then return end

  for optionIndex = 1, optionCount + 1 do
    local optionString, optionType = GetChatterOption(optionIndex)

    if optionType == CHATTER_START_NEW_QUEST_BESTOWAL then
      QuestAutomation.questOffered = false
      EVENT_MANAGER:RegisterForEvent(
        QUEST_OFFERED_EVENT_NAME,
        EVENT_QUEST_OFFERED,
        HandleQuestOffered
      )
      SelectChatterOption(optionIndex)
      break
    elseif optionType == CHATTER_START_TALK and IsPledgeGiver(npcName) and HasCompletedUndauntedPrerequisite() then
      -- Pledges hide EVENT_QUEST_COMPLETE_DIALOG behind one chatter start
      QuestAutomation.questCompleted = false
      EVENT_MANAGER:RegisterForEvent(
        CONVERSATION_UPDATED_EVENT_NAME,
        EVENT_CONVERSATION_UPDATED,
        HandleConversationUpdated
      )
      SelectChatterOption(optionIndex)
      break
    elseif optionType == CHATTER_START_COMPLETE_QUEST then
      QuestAutomation.questCompleted = false
      EVENT_MANAGER:RegisterForEvent(
        QUEST_COMPLETED_EVENT_NAME,
        EVENT_QUEST_COMPLETE_DIALOG,
        HandleQuestCompleted
      )
      SelectChatterOption(optionIndex)
      break
    end
  end
end

--- Handler for chatter begin event.
--- @param _ any Unused event code
--- @param optionCount number Number of dialog options
--- @param _debugSource_ any Debug source info
local function HandleChatterBegin(_, optionCount, _debugSource_)
  local npcName = GetUnitName("interact")
  QuestAutomation.currentNpcName = npcName
  QuestAutomation.currentOptionCount = optionCount

  -- Check if automation already in progress
  if QuestAutomation.questOffered or QuestAutomation.questCompleted then
    EndInteraction(INTERACTION_CONVERSATION)
    return
  end

  -- Check if this is a daily NPC
  if not IsDailyNpc(npcName) then
    return
  end

  -- Get opt-in status from UI module
  local optInStatus = GAFE.QuestAutomationUI.GetOptInStatus(npcName)

  if optInStatus == true then
    -- Opted in: run automation immediately
    ProcessDialogOptions(optionCount, npcName)
  elseif optInStatus == false then
    -- Explicitly disabled: do nothing
    return
  else
    -- Undecided (nil): show opt-in prompt
    GAFE.QuestAutomationUI.ShowOptInPrompt(npcName)
  end
end

--- Handler for chatter end event.
local function HandleChatterEnd()
  QuestAutomation.questOffered = false
  QuestAutomation.questCompleted = false
  QuestAutomation.currentNpcName = nil
  QuestAutomation.currentOptionCount = 0

  -- Clean up any pending opt-in prompt
  GAFE.QuestAutomationUI.HideOptInPrompt()
end

-- ============================================================================
-- Public Functions
-- ============================================================================

--- Initializes the quest automation module.
--- Populates NPC name lists from LibQuestData for daily and crafting writ quests.
function QuestAutomation.Init()
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

        if isCraftingWrit and not contains(QuestAutomation.craftingWritNpcName, npcName) then
          table_insert(QuestAutomation.craftingWritNpcName, npcName)
        elseif not contains(QuestAutomation.dailyNpcName, npcName) then
          table_insert(QuestAutomation.dailyNpcName, npcName)
        end
      end
    end
  end

  -- Initialize UI module
  GAFE.QuestAutomationUI.Init()

  -- Always register for chatter events (opt-in check happens inside)
  QuestAutomation.RegisterEvents()
end

--- Registers event handlers for quest automation.
function QuestAutomation.RegisterEvents()
  EVENT_MANAGER:RegisterForEvent(
    CHATTER_BEGIN_EVENT_NAME,
    EVENT_CHATTER_BEGIN,
    HandleChatterBegin
  )
  EVENT_MANAGER:RegisterForEvent(
    CHATTER_END_EVENT_NAME,
    EVENT_CHATTER_END,
    HandleChatterEnd
  )
end

--- Unregisters event handlers for quest automation.
function QuestAutomation.UnregisterEvents()
  EVENT_MANAGER:UnregisterForEvent(CHATTER_BEGIN_EVENT_NAME, EVENT_CHATTER_BEGIN)
  EVENT_MANAGER:UnregisterForEvent(CHATTER_END_EVENT_NAME, EVENT_CHATTER_END)
  EVENT_MANAGER:UnregisterForEvent(QUEST_OFFERED_EVENT_NAME, EVENT_QUEST_OFFERED)
  EVENT_MANAGER:UnregisterForEvent(QUEST_COMPLETED_EVENT_NAME, EVENT_QUEST_COMPLETE_DIALOG)
  EVENT_MANAGER:UnregisterForEvent(CONVERSATION_UPDATED_EVENT_NAME, EVENT_QUEST_OFFERED)
end

--- Executes automation for a specific NPC.
--- Called by the UI when user opts in via keybind/button.
--- @param npcName string The NPC name to automate
function QuestAutomation.ExecuteAutomation(npcName)
  -- Use stored option count from the chatter begin event
  local optionCount = QuestAutomation.currentOptionCount

  -- If we have options, process them
  if optionCount > 0 then
    ProcessDialogOptions(optionCount, npcName)
  end
end

-- ============================================================================
-- Module Registration
-- ============================================================================
GAFE.QuestAutomation = QuestAutomation
