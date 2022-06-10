local GAFE = GroupActivityFinderExtensions

local extender = GAFE_ActivityFinderExtender:New()

local function UpdateChestLabel(label, characterId, questId)
    local chestText = ""
    local timeUntilNextChest = GAFE_TRIALS_CHESTS.GetTimeUntilNextChest(characterId, questId)
    if timeUntilNextChest > 0 then
        chestText = GAFE.ParseTimeStamp(timeUntilNextChest)
    else
        EVENT_MANAGER:UnregisterForUpdate(GAFE.name .. "_chest" .. questId)
    end
    label:SetText(chestText)
end

local function AddChest(_questId_, _control_)
    local questId, control = _questId_, _control_

    local characterId = GetCurrentCharacterId()
    local chestAvailable = GAFE_TRIALS_CHESTS.GetTimeUntilNextChest(characterId, questId) <= 0
    local text = control.text:GetText()
    if chestAvailable == true then
        text = "|cFFD700" .. text .. "|r"
    else
        local chestLabel = GAFE.UI.Label(control:GetName() .. "c", control, { 125, 20 }, { LEFT, control, LEFT, 310, -1 }, 'ZoFontWinH4')
        UpdateChestLabel(chestLabel, characterId, questId)
        -- EVENT_MANAGER:RegisterForUpdate(GAFE.name .. "_chest" .. questId, 1000, function() UpdateChestLabel(chestLabel, characterId, questId) end)
        chestLabel:SetHandler("OnUpdate", function() UpdateChestLabel(chestLabel, characterId, questId) end)
    end
    control.text:SetText(text)
end

GAFE_TRIALS_EXTENSIONS = {}

function GAFE_TRIALS_EXTENSIONS.Init()
    local trialsData = GAFE_TRIALS_ACTIVITY_DATA
    local treeEntry = TRIAL_FINDER_KEYBOARD.navigationTree.templateInfo.ZO_ActivityFinderTemplateNavigationEntry_Keyboard

    local function customExtensions(node, control, data, open)
        local activityId = data.id
        local activityData = trialsData[activityId]
        if activityData then
            -- Chest
            AddChest(activityData.q, control)
        end
    end

    extender:Initialize("GAFE_Trial", trialsData, treeEntry, customExtensions, nil, nil, nil)
end
