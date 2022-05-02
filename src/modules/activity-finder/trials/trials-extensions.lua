local GAFE = GroupActivityFinderExtensions

local extender = GAFE_ActivityFinderExtender:New()

local function AddChest(_control_)
    local control = _control_

    -- local characterId = GetCurrentCharacterId()
    -- local text = control.text:GetText()
    -- local donePledges = GAFE.SavedVars.dungeons.donePledges[characterId]

    -- local pledgeName = PledgeQuestName[DungeonActivityData[activityId].p]:lower()
    -- local questCompleted=pledgeQuests[pledgeName]
    -- local questGivedIn = donePledges[DungeonActivityData[activityId].p]
    -- local isTodaysPledge = IsTodaysPledge(activityId)
    -- -- Save if it needs to be checked
    -- control.pledge=questCompleted==false
    -- if questCompleted==true or questGivedIn then
    --     -- In Journal and completed or done and not in journal
    --     text="|c32CD32"..text.."|r"
    -- elseif questCompleted==false then
    --     -- In Journal and no completed
    --     text="|cFFD700"..text.."|r"
    -- elseif isTodaysPledge then
    --     -- Not done and not in journal
    --     text="|c00CED1"..text.."|r"
    -- end
    -- control.text:SetText(text)
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
            AddChest(control)
        end
    end

    extender:Initialize("GAFE_Trial", trialsData, treeEntry, customExtensions, nil, nil, nil)
end
