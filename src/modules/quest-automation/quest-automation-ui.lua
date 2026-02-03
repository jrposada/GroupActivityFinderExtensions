-- ============================================================================
-- Localized Globals
-- ============================================================================
local EVENT_MANAGER = EVENT_MANAGER
local KEYBIND_STRIP = KEYBIND_STRIP
local ZO_Dialogs_RegisterCustomDialog = ZO_Dialogs_RegisterCustomDialog
local ZO_Dialogs_ShowDialog = ZO_Dialogs_ShowDialog
local GetCurrentCharacterId = GetCurrentCharacterId

local GAFE = GroupActivityFinderExtensions

-- ============================================================================
-- Constants
-- ============================================================================
local DIALOG_NAME = "GAFE_QUEST_AUTOMATION_CONFIRM"

-- ============================================================================
-- Module Declaration
-- ============================================================================
local QuestAutomationUI = {
  control = nil,
  button = nil,
  pendingNpcName = nil,
  keybindDescriptor = nil
}

-- ============================================================================
-- Private Functions
-- ============================================================================

--- Saves the opt-in preference for an NPC.
--- @param npcName string The NPC name
--- @param value boolean True to opt in, false to opt out
local function SaveOptInPreference(npcName, value)
  local characterId = GetCurrentCharacterId()
  local optIn = GAFE.SavedVars.questAutomation.optIn

  if not optIn[characterId] then
    optIn[characterId] = {}
  end

  optIn[characterId][npcName] = value
end

--- Shows the confirmation dialog to remember the preference.
--- @param npcName string The NPC name to save preference for
local function ShowConfirmationDialog(npcName)
  ZO_Dialogs_ShowDialog(DIALOG_NAME, { npcName = npcName })
end

--- Callback when the user activates opt-in (via keybind or button).
local function OptInAndAutomate()
  local npcName = QuestAutomationUI.pendingNpcName
  if not npcName then return end

  -- Hide the prompt immediately
  QuestAutomationUI.HideOptInPrompt()

  -- Trigger the automation for this interaction
  GAFE.QuestAutomation.ExecuteAutomation(npcName)

  -- Show confirmation dialog to save preference
  ShowConfirmationDialog(npcName)
end

-- ============================================================================
-- Public Functions
-- ============================================================================

--- Initializes the Quest Automation UI module.
--- Registers the confirmation dialog.
function QuestAutomationUI.Init()
  -- Register confirmation dialog
  ZO_Dialogs_RegisterCustomDialog(DIALOG_NAME, {
    title = {
      text = GAFE.Loc("QuestAutomation_ConfirmTitle")
    },
    mainText = {
      text = GAFE.Loc("QuestAutomation_ConfirmText")
    },
    buttons = {
      {
        text = SI_DIALOG_CONFIRM,
        callback = function(dialog)
          local npcName = dialog.data.npcName
          SaveOptInPreference(npcName, true)
        end
      },
      {
        text = SI_DIALOG_DECLINE
        -- Do nothing - one-time automation only
      }
    }
  })

  -- Create keybind descriptor
  QuestAutomationUI.keybindDescriptor = {
    alignment = KEYBIND_STRIP_ALIGN_CENTER,
    name = GAFE.Loc("QuestAutomation_OptInKeybind"),
    keybind = "UI_SHORTCUT_QUINARY",
    callback = OptInAndAutomate,
    visible = function()
      return QuestAutomationUI.pendingNpcName ~= nil
    end
  }
end

--- Shows the opt-in prompt for the given NPC.
--- @param npcName string The NPC name to show prompt for
function QuestAutomationUI.ShowOptInPrompt(npcName)
  QuestAutomationUI.pendingNpcName = npcName

  -- Show button
  if QuestAutomationUI.control then
    QuestAutomationUI.control:SetHidden(false)
  end

  -- Add keybind to strip
  KEYBIND_STRIP:AddKeybindButton(QuestAutomationUI.keybindDescriptor)
end

--- Hides the opt-in prompt and cleans up state.
function QuestAutomationUI.HideOptInPrompt()
  QuestAutomationUI.pendingNpcName = nil

  -- Hide button
  if QuestAutomationUI.control then
    QuestAutomationUI.control:SetHidden(true)
  end

  -- Remove keybind from strip
  KEYBIND_STRIP:RemoveKeybindButton(QuestAutomationUI.keybindDescriptor)
end

--- Gets the opt-in status for an NPC on the current character.
--- @param npcName string The NPC name
--- @return boolean|nil status True if opted in, false if disabled, nil if undecided
function QuestAutomationUI.GetOptInStatus(npcName)
  local characterId = GetCurrentCharacterId()
  local optIn = GAFE.SavedVars.questAutomation.optIn

  if not optIn[characterId] then
    return nil
  end

  return optIn[characterId][npcName]
end

--- Sets the opt-in status for an NPC on the current character.
--- @param npcName string The NPC name
--- @param value boolean|nil True to opt in, false to opt out, nil to reset
function QuestAutomationUI.SetOptInStatus(npcName, value)
  SaveOptInPreference(npcName, value)
end

--- Resets all opt-in preferences for the current character.
function QuestAutomationUI.ResetAllPreferences()
  local characterId = GetCurrentCharacterId()
  GAFE.SavedVars.questAutomation.optIn[characterId] = {}
end

--- Gets all opted-in NPCs for the current character.
--- @return table npcs Table of { npcName = status } pairs
function QuestAutomationUI.GetAllOptedInNpcs()
  local characterId = GetCurrentCharacterId()
  local optIn = GAFE.SavedVars.questAutomation.optIn

  if not optIn[characterId] then
    return {}
  end

  return optIn[characterId]
end

-- ============================================================================
-- XML Callbacks
-- ============================================================================

--- Called when the opt-in button control is initialized.
--- @param control userdata The UI control
function GAFE_QuestAutomationUI_OnInitialized(control)
  QuestAutomationUI.control = control
  QuestAutomationUI.button = control:GetNamedChild("Button")

  if QuestAutomationUI.button then
    ZO_KeybindButtonTemplate_Setup(
      QuestAutomationUI.button,
      "UI_SHORTCUT_QUINARY",
      OptInAndAutomate,
      GAFE.Loc("QuestAutomation_OptInKeybind")
    )
  end
end

--- Called when the opt-in button is clicked.
function GAFE_QuestAutomationUI_OnButtonClicked()
  OptInAndAutomate()
end

-- ============================================================================
-- Module Registration
-- ============================================================================
GAFE.QuestAutomationUI = QuestAutomationUI
