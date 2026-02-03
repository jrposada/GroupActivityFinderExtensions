local GAFE = GroupActivityFinderExtensions
local LAM = LibAddonMenu2

local GetCurrentCharacterId = GetCurrentCharacterId
local pairs = pairs

local characterId = GetCurrentCharacterId()

GAFE.SettingsMenu = {}

local collapseModeToString = {
  [GAFE.COLLAPSE_MODE.Group] = GAFE.Loc("CollapseMode_Group"),
  [GAFE.COLLAPSE_MODE.Normal] = GAFE.Loc("CollapseMode_Normal"),
  [GAFE.COLLAPSE_MODE.Veteran] = GAFE.Loc("CollapseMode_Veteran")
}
local stringToCollapseMode = {
  [GAFE.Loc("CollapseMode_Group")] = GAFE.COLLAPSE_MODE.Group,
  [GAFE.Loc("CollapseMode_Normal")] = GAFE.COLLAPSE_MODE.Normal,
  [GAFE.Loc("CollapseMode_Veteran")] = GAFE.COLLAPSE_MODE.Veteran,
}

local fastTravelNodesByName = {}
local fastTravelNodesById = {}
local fastTravelOptions = {}
for id = 1, GetNumFastTravelNodes() do
  local _, name = GetFastTravelNodeInfo(id)
  if name ~= "" then
    fastTravelNodesByName[name] = id
    fastTravelNodesById[id] = name
    table.insert(fastTravelOptions, name)
  end
end
table.sort(fastTravelOptions)

--- Builds the controls for the Quest Automation submenu.
--- Dynamically generates checkboxes for each opted-in NPC.
--- @return table controls Array of LAM control definitions
function GAFE.SettingsMenu.BuildQuestAutomationControls()
  local controls = {}

  -- Description
  table.insert(controls, {
    type = "description",
    text = GAFE.Loc("Settings_QuestAutomation_Desc")
  })

  -- Get all opted-in NPCs for current character
  local optedInNpcs = GAFE.QuestAutomationUI and GAFE.QuestAutomationUI.GetAllOptedInNpcs() or {}
  local hasNpcs = false

  -- Sort NPC names for consistent display
  local sortedNpcs = {}
  for npcName, _ in pairs(optedInNpcs) do
    table.insert(sortedNpcs, npcName)
    hasNpcs = true
  end
  table.sort(sortedNpcs)

  if hasNpcs then
    -- Generate a checkbox for each NPC
    for _, npcName in ipairs(sortedNpcs) do
      table.insert(controls, {
        type = "checkbox",
        name = npcName,
        getFunc = function()
          local status = GAFE.QuestAutomationUI.GetOptInStatus(npcName)
          return status == true
        end,
        setFunc = function(value)
          if value then
            GAFE.QuestAutomationUI.SetOptInStatus(npcName, true)
          else
            -- Setting to nil removes from the list (undecided state)
            GAFE.QuestAutomationUI.SetOptInStatus(npcName, nil)
          end
        end
      })
    end

    -- Add divider before reset button
    table.insert(controls, {
      type = "divider"
    })

    -- Reset all button
    table.insert(controls, {
      type = "button",
      name = GAFE.Loc("Settings_QuestAutomation_Reset"),
      func = function()
        GAFE.QuestAutomationUI.ResetAllPreferences()
      end,
      warning = GAFE.Loc("Settings_QuestAutomation_ResetWarning"),
      isDangerous = true
    })
  else
    -- No NPCs opted in yet
    table.insert(controls, {
      type = "description",
      text = GAFE.Loc("Settings_QuestAutomation_NoNpcs")
    })
  end

  return controls
end

function GAFE.SettingsMenu.Init()
  local saveData = GAFE
      .SavedVars       -- This should be a reference to your actual saved variables table
  local panelName = GAFE.name ..
      "_SettingsPanel" -- The name will be used to create a global variable, pick something unique or you may overwrite an existing variable!

  local panelData = {
    type = "panel",
    name = "Group & Activity Finder Extensions",
    author = "Panicida",
    registerForRefresh = true
  }
  local optionsData = {
    {
      type = "description",
      text = GAFE.Loc("Settings_Description")
    },
    {
      type = "slider",
      name = GAFE.Loc("Settings_TextureSize"),
      getFunc = function() return saveData.textureSize end,
      setFunc = function(value) saveData.textureSize = value end,
      max = 30,
      min = 20,
      step = 1,
    },
    {
      type = "dropdown",
      name = GAFE.Loc("Settings_Difficulty"),
      choices = { collapseModeToString[GAFE.COLLAPSE_MODE.Group],
        collapseModeToString[GAFE.COLLAPSE_MODE.Normal],
        collapseModeToString[GAFE.COLLAPSE_MODE.Veteran] },
      getFunc = function() return collapseModeToString[saveData.collapse] end,
      setFunc = function(value) saveData.collapse = stringToCollapseMode[value] end
    },
    {
      type = "slider",
      name = GAFE.Loc("Settings_AutoConfirmDelay"),
      getFunc = function() return saveData.autoConfirm.delay / 1000 end,
      setFunc = function(value) saveData.autoConfirm.delay = value * 1000 end,
      max = 40,
      min = 1,
      step = 1,
    },
    {
      type = "checkbox",
      name = GAFE.Loc("Settings_LoopQueueCompletedNotification"),
      getFunc = function() return saveData.autoConfirm.loopSound end,
      setFunc = function(value) saveData.autoConfirm.loopSound = value end
    },
    {
      type = "dropdown",
      name = GAFE.Loc("Settings_FavouriteLocation"),
      choices = fastTravelOptions,
      scrollable = true,
      getFunc = function() return fastTravelNodesById[saveData.map.favourite] end,
      setFunc = function(value)
        saveData.map.favourite = fastTravelNodesByName
            [value]
      end
    },
    {
      type = "checkbox",
      name = GAFE.Loc("Settings_TTCPrice"),
      tooltip = GAFE.Loc("Settings_TTCPrice_Tooltip"),
      getFunc = function()
        -- Return false when Master Merchant's price replacement is enabled
        if MasterMerchant and MasterMerchant.systemSavedVariables and MasterMerchant.systemSavedVariables.replaceInventoryValues then
          return false
        end
        return saveData.ttcPrice.enabled
      end,
      setFunc = function(value)
        saveData.ttcPrice.enabled = value
      end,
      disabled = function()
        return MasterMerchant and MasterMerchant.systemSavedVariables and MasterMerchant.systemSavedVariables.replaceInventoryValues
      end,
      warning = function()
        if MasterMerchant and MasterMerchant.systemSavedVariables and MasterMerchant.systemSavedVariables.replaceInventoryValues then
          return GAFE.Loc("Settings_TTCPrice_MasterMerchantConflict")
        end
      end,
      requiresReload = true
    },
    {
      type = "submenu",
      name = GAFE.Loc("Settings_QuestAutomation"),
      controls = GAFE.SettingsMenu.BuildQuestAutomationControls()
    },
    {
      type = "submenu",
      name = GAFE.Loc("Settings_CompatibilityTitle"),
      controls = {
        {
          type = "checkbox",
          name = GAFE.Loc("Settings_PerfectPixelAddon"),
          getFunc = function() return saveData.compatibility.perfectPixel end,
          setFunc = function(value) saveData.compatibility.perfectPixel = value end,
          requiresReload = true
        },
      }
    },
    {
      type = "divider"
    },
    {
      type = "submenu",
      name = GAFE.Loc("Settings_ResetPremiumRewards"),
      controls = {
        {
          type = "button",
          name = GetString(SI_DUNGEON_FINDER_GENERAL_ACTIVITY_DESCRIPTOR),
          func = function()
            GAFE.SavedVars.dungeons.randomRewards[characterId] =
                GetTimeStamp()
          end,
          width = "half",
          warning = GAFE.Loc("Settings_ResetReward"),
          isDangerous = true
        },
        {
          type = "button",
          name = GetString(SI_BATTLEGROUND_FINDER_GENERAL_ACTIVITY_DESCRIPTOR),
          func = function()
            GAFE.SavedVars.battlegrounds.randomRewards[characterId] =
                GetTimeStamp()
          end,
          width = "half",
          warning = GAFE.Loc("Settings_ResetReward"),
          isDangerous = true
        }
      }
    },
    {
      type = "divider"
    },
    {
      type = "submenu",
      name = GAFE.Loc("Settings_TrialsChest"),
      controls = {
        {
          type = "button",
          name = GAFE.Loc("TrialAetherianArchive"),
          func = function()
            return GAFE.TrialsChests.ResetChest(GAFE.TRIALS_ACTIVITY_DATA[
            GAFE.ACTIVITY_ID.NormalAetherianArchive].q)
          end,
          width = "half",
          warning = GAFE.Loc("Settings_ResetChestWarning"),
          isDangerous = true
        },
        {
          type = "button",
          name = GAFE.Loc("TrialHelRaCitadel"),
          func = function()
            return GAFE.TrialsChests.ResetChest(GAFE.TRIALS_ACTIVITY_DATA[
            GAFE.ACTIVITY_ID.NormalHelRaCitadel].q)
          end,
          width = "half",
          warning = GAFE.Loc("Settings_ResetChestWarning"),
          isDangerous = true
        },
        {
          type = "button",
          name = GAFE.Loc("TrialSanctumOphidia"),
          func = function()
            return GAFE.TrialsChests.ResetChest(GAFE.TRIALS_ACTIVITY_DATA[
            GAFE.ACTIVITY_ID.NormalSanctumOphidia].q)
          end,
          width = "half",
          warning = GAFE.Loc("Settings_ResetChestWarning"),
          isDangerous = true
        },
        {
          type = "button",
          name = GAFE.Loc("TrialMawOfLorkhaj"),
          func = function()
            return GAFE.TrialsChests.ResetChest(GAFE.TRIALS_ACTIVITY_DATA[
            GAFE.ACTIVITY_ID.NormalMawOfLorkhaj].q)
          end,
          width = "half",
          warning = GAFE.Loc("Settings_ResetChestWarning"),
          isDangerous = true
        },
        {
          type = "button",
          name = GAFE.Loc("TrialHallsOfFabrication"),
          func = function()
            return GAFE.TrialsChests.ResetChest(GAFE.TRIALS_ACTIVITY_DATA[
            GAFE.ACTIVITY_ID.NormalHallsOfFabrication].q)
          end,
          width = "half",
          warning = GAFE.Loc("Settings_ResetChestWarning"),
          isDangerous = true
        },
        {
          type = "button",
          name = GAFE.Loc("TrialAsylumSanctorium"),
          func = function()
            return GAFE.TrialsChests.ResetChest(GAFE.TRIALS_ACTIVITY_DATA[
            GAFE.ACTIVITY_ID.NormalAsylumSanctorium].q)
          end,
          width = "half",
          warning = GAFE.Loc("Settings_ResetChestWarning"),
          isDangerous = true
        },
        {
          type = "button",
          name = GAFE.Loc("TrialCloudrest"),
          func = function()
            return GAFE.TrialsChests.ResetChest(GAFE.TRIALS_ACTIVITY_DATA[
            GAFE.ACTIVITY_ID.NormalCloudrest].q)
          end,
          width = "half",
          warning = GAFE.Loc("Settings_ResetChestWarning"),
          isDangerous = true
        },
        {
          type = "button",
          name = GAFE.Loc("TrialSunspire"),
          func = function()
            return GAFE.TrialsChests.ResetChest(GAFE.TRIALS_ACTIVITY_DATA[
            GAFE.ACTIVITY_ID.NormalSunspire].q)
          end,
          width = "half",
          warning = GAFE.Loc("Settings_ResetChestWarning"),
          isDangerous = true
        },
        {
          type = "button",
          name = GAFE.Loc("TrialKynesAegis"),
          func = function()
            return GAFE.TrialsChests.ResetChest(GAFE.TRIALS_ACTIVITY_DATA[
            GAFE.ACTIVITY_ID.NormalKynesAegis].q)
          end,
          width = "half",
          warning = GAFE.Loc("Settings_ResetChestWarning"),
          isDangerous = true
        },
        {
          type = "button",
          name = GAFE.Loc("TrialDreadsailReef"),
          func = function()
            return GAFE.TrialsChests.ResetChest(GAFE.TRIALS_ACTIVITY_DATA[
            GAFE.ACTIVITY_ID.NormalDreadsailReef].q)
          end,
          width = "half",
          warning = GAFE.Loc("Settings_ResetChestWarning"),
          isDangerous = true
        },
      },
    },
    {
      type = "submenu",
      name = "Developer",
      controls = {
        {
          type = "checkbox",
          name = 'Developer mode',
          getFunc = function() return saveData.developerMode end,
          setFunc = function(value) saveData.developerMode = value end,
          warning = "Intended only for developers",
          isDangerous = true
        },
        {
          type = "checkbox",
          name = 'Enable BETA features',
          getFunc = function() return saveData.beta end,
          setFunc = function(value) saveData.beta = value end,
          warning = "Unestable features. Addon may crash or not work as intended",
          isDangerous = true,
          requiresReload = true
        }
      }
    },
  }

  LAM:RegisterAddonPanel(panelName, panelData)
  LAM:RegisterOptionControls(panelName, optionsData)
end
