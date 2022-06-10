local GAFE = GroupActivityFinderExtensions

GAFE_ActivityFinderExtender = ZO_Object:Subclass()

function GAFE_ActivityFinderExtender:New()
    local activityFinderExtender = ZO_Object.New(self)
    return activityFinderExtender
end

function GAFE_ActivityFinderExtender:Initialize(_root_, _data_, _treeEntry_, _customExtensions_, _rewardsVars_, _keybindStripGroup_, _onShown_)
    local root, data, treeEntry, customExtensions, rewardsVars, keybindStripGroup, onShown =
    _root_, _data_, _treeEntry_, _customExtensions_, _rewardsVars_, _keybindStripGroup_, _onShown_

    self.characterId = GetCurrentCharacterId()
    self.root = root
    self.data = data
    self.customExtensions = customExtensions
    self.rewardsVars = rewardsVars
    self.onShown = onShown
    self.textureSize = GroupActivityFinderExtensions.SavedVars.textureSize
    self.leaveGroupKeybindStripGroup = {
        {
            -- Leave Group
            alignment = KEYBIND_STRIP_ALIGN_CENTER,
            name = GetString(SI_GROUP_LEAVE),
            keybind = "UI_SHORTCUT_NEGATIVE",
            callback = function()
                ZO_Dialogs_ShowDialog("GROUP_LEAVE_DIALOG")
            end,
            visible = function()
                return GROUP_LIST.groupSize and GROUP_LIST.groupSize > 0
            end
        }
    }
    self.keybindStripGroup = {
        self.leaveGroupKeybindStripGroup[0]
    }
    if keybindStripGroup then
        for _, item in pairs(keybindStripGroup) do
            table.insert(self.keybindStripGroup, item)
        end
    end

    if treeEntry then self:InitializeSetupFunction(treeEntry) end
    self:InitializeRandomReward()
    self:InitializeEvents()
end

function GAFE_ActivityFinderExtender:InitializeSetupFunction(_treeEntry_)
    local treeEntry = _treeEntry_

    local baseSetupFunction = treeEntry.setupFunction
    self.pool = treeEntry.objectPool

    local function setupFunction(node, control, data, open)
        baseSetupFunction(node, control, data, open)

        local activityId = data.id
        local activityData = self.data[activityId]
        if activityData then
            self.position = 530

            -- Sets
            self:AddSets(activityData.sets, control)

            -- Survivor challenge (no death)
            self:AddAchievement(
                activityData.nd,
                control:GetName() .. "nd",
                control,
                "/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds"
            )
            -- Speed challenge
            self:AddAchievement(
                activityData.tt,
                control:GetName() .. "tt",
                control,
                "/esoui/art/ava/overview_icon_underdog_score.dds"
            )
            -- Death challenge (hard mode)
            self:AddAchievement(
                activityData.hm,
                control:GetName() .. "hm",
                control,
                "/esoui/art/unitframes/target_veteranrank_icon.dds"
            )
            -- General Vanquisher (normal) / Conqueror (veteran)
            self:AddAchievement(
                activityData.id,
                control:GetName() .. "id",
                control,
                "/esoui/art/announcewindow/announcement_icon_up.dds"
            )

            -- Quest (skill point)
            self:AddQuest(
                activityData.q,
                control:GetName() .. "q",
                control,
                "/esoui/art/icons/achievements_indexicon_quests_up.dds"
            )

            -- Wayshrine
            self:AddWayshrine(activityData.node, control)
        else
            -- TODO:
            GAFE.UI.AddIcon(control:GetName() .. "TODO", control, { 125, 20 }, { LEFT, control, LEFT, 420, 0 }, "ZoFontGameLarge", nil, { 0, 1 }, "TODO " .. activityId)
        end

        if (self.customExtensions) then self.customExtensions(node, control, data, open) end
    end

    treeEntry.setupFunction = setupFunction
end

function GAFE_ActivityFinderExtender:InitializeRandomReward()
    -- Initialize control.
    self.singularSectionRewards = _G[self.root .. "Finder_Keyboard" .. "SingularSectionRewardsSectionHeader"]
    if self.singularSectionRewards then
        self.premiumRewardTimerControl = GAFE.UI.Label(self.root .. "_RandomReward", self.singularSectionRewards, { 125, 20 }, { TOPLEFT, self.parent, TOPRIGHT, 10, 2 }, "ZoFontGameShadow", nil, { 0, 1 })
    end
end

function GAFE_ActivityFinderExtender:InitializeEvents()
    local function OnKeyboardListSectionShown()
        KEYBIND_STRIP:AddKeybindButtonGroup(self.keybindStripGroup)
        self:Collapse()
        if self.onShown then self.onShown() end
    end

    local function OnKeyboardListSectionHidden()
        KEYBIND_STRIP:RemoveKeybindButtonGroup(self.keybindStripGroup)
    end

    local function OnSingularSectionShown()
        KEYBIND_STRIP:AddKeybindButtonGroup(self.leaveGroupKeybindStripGroup)
        if self.onShown then self.onShown() end
    end

    local function OnSingularSectionHidden()
        KEYBIND_STRIP:RemoveKeybindButtonGroup(self.leaveGroupKeybindStripGroup)
    end

    local keyboardSection = _G[self.root .. 'Finder_KeyboardListSection']
    if keyboardSection then
        ZO_PreHookHandler(keyboardSection, 'OnEffectivelyShown', OnKeyboardListSectionShown)
        ZO_PreHookHandler(keyboardSection, 'OnEffectivelyHidden', OnKeyboardListSectionHidden)
    end

    local singularSection = _G[self.root .. 'Finder_KeyboardSingularSection']
    if singularSection then
        ZO_PreHookHandler(singularSection, 'OnEffectivelyShown', OnSingularSectionShown)
        ZO_PreHookHandler(singularSection, 'OnEffectivelyHidden', OnSingularSectionHidden)
    end

    if self.singularSectionRewards then
        local eventName = self.root .. '_RandomEvent'
        local function OnRandomActivitySectionShown()
            local function Update()
                self:UpdatePurpleRewardTimer()
            end

            self:UpdatePurpleRewardTimer()
            EVENT_MANAGER:RegisterForUpdate(eventName, 1000, Update)
        end

        local function OnRandomActivitySectionHidden()
            EVENT_MANAGER:UnregisterForUpdate(eventName)
        end

        ZO_PreHookHandler(self.singularSectionRewards, 'OnEffectivelyShown', OnRandomActivitySectionShown)
        ZO_PreHookHandler(self.singularSectionRewards, 'OnEffectivelyHidden', OnRandomActivitySectionHidden)
    end
end

function GAFE_ActivityFinderExtender:AddAchievement(_achivementId_, _controlName_, _parent_, _texture_)
    local achievementId, controlName, parent, texture =
    _achivementId_, _controlName_, _parent_, _texture_
    local sceneManager = SCENE_MANAGER
    local achievements = ACHIEVEMENTS

    local function showAchievement()
        if select(1, GetCategoryInfoFromAchievementId(achievementId)) ~= nil then
            sceneManager:ShowBaseScene()
            achievements:ShowAchievement(achievementId)
        end
    end

    local text, hidden, tooltip = nil, false, nil
    if achievementId then
        local achievementName, _, _, icon, isCompleted, _, _ = GetAchievementInfo(achievementId)
        text = isCompleted and self:FormatTexture(texture) or ""
        tooltip = self:FormatTexture(icon) .. zo_strformat(achievementName)
        hidden = not isCompleted
    elseif GAFE.developerMode then
        text = "-"
        hidden = false
    end

    return self:AddIcon(controlName, parent, text, showAchievement, tooltip, hidden)
end

function GAFE_ActivityFinderExtender:AddQuest(_questId_, _controlName_, _parent_, _texture_)
    local questId, controlName, parent, texture = _questId_, _controlName_, _parent_, _texture_

    local text, isQuestCompleted = nil, false
    if questId then
        isQuestCompleted = GetCompletedQuestInfo(questId) ~= "" and true or false
        text = isQuestCompleted and self:FormatTexture(texture) or ""
        parent.gafeQuest = not isQuestCompleted
        self.hasQuests = self.hasQuests or parent.gafeQuest
    elseif GAFE.developerMode then
        text = "-"
    end

    return self:AddIcon(controlName, parent, text, nil, nil, parent.gafeQuest)
end

function GAFE_ActivityFinderExtender:AddWayshrine(_nodeIndex_, _parent_)
    local nodeIndex, parent = _nodeIndex_, _parent_
    local text, knownNode, name = nil, nil, nil

    local function FastTravel()
        ZO_Dialogs_ShowPlatformDialog("RECALL_CONFIRM", { nodeIndex = nodeIndex }, { mainTextParams = { name } })
    end

    if nodeIndex then
        knownNode, name = GetFastTravelNodeInfo(nodeIndex)
        text = knownNode and self:FormatTexture("/esoui/art/icons/poi/poi_wayshrine_complete.dds") or ""
    elseif GAFE.developerMode then
        text = "-"
    end

    return GAFE.UI.Button(
        parent:GetName() .. "t",
        parent,
        { self.textureSize, self.textureSize },
        { RIGHT, parent, LEFT, -5, 0 },
        text,
        FastTravel,
        true,
        nil,
        not knownNode
    )
end

function GAFE_ActivityFinderExtender:AddSets(_setsIds_, _parent_)
    local setsIds, parent = _setsIds_, _parent_

    local text, hasAllSets = nil, true
    if setsIds then
        for _, setId in pairs(setsIds) do
            local setCollectionData = ITEM_SET_COLLECTIONS_DATA_MANAGER:GetItemSetCollectionData(setId)
            local numUnlockedPieces, numPieces = setCollectionData:GetNumUnlockedPieces(), setCollectionData:GetNumPieces()
            hasAllSets = hasAllSets and numUnlockedPieces == numPieces
        end

        text = hasAllSets and self:FormatTexture("/esoui/art/crafting/smithing_tabicon_armorset_up.dds") or ""
        parent.gafeSets = not hasAllSets
    elseif GAFE.developerMode then
        text = "-"
    end

    return self:AddIcon(parent:GetName() .. "sets", parent, text, nil, nil, parent.gafeSets)
end

function GAFE_ActivityFinderExtender:FormatTexture(texture, size)
    if size == nil then size = self.textureSize end
    return "|t" .. size .. ":" .. size .. ":" .. texture .. "|t"
end

function GAFE_ActivityFinderExtender:AddIcon(_controlName_, _parent_, _text_, _func_, _tooltip_, _hidden_)
    local controlName, parent, text, func, tooltip, hidden =
    _controlName_, _parent_, _text_, _func_, _tooltip_, _hidden_

    local position = self.position
    self.position = position - self.textureSize

    return GAFE.UI.Button(
        controlName,
        parent,
        { self.textureSize, self.textureSize },
        { LEFT, parent, LEFT, self.position, 0 },
        text,
        func,
        true,
        tooltip,
        hidden
    )
end

function GAFE_ActivityFinderExtender:Collapse()
    local function collapse()
        self:RefreshDungeonDifficulty()
        for c = 2, 3 do
            local header = _G[self.root .. "Finder_KeyboardListSectionScrollChildZO_ActivityFinderTemplateNavigationHeader_Keyboard" .. c - 1]
            if header then
                local state = header.text:GetColor()
                if ((self.dungeonDifficulty ~= c) == (state == 1)) then header:OnMouseUp(true) end
            end
        end
    end

    GAFE.CallLater(GAFE.name .. self.root .. "_Extensions", 200, collapse)
end

function GAFE_ActivityFinderExtender:UpdatePurpleRewardTimer()
    local timeUntilNextReward = self.GetTimeUntilNextReward(self.characterId, self.rewardsVars)

    if timeUntilNextReward > 0 then
        self.premiumRewardTimerControl:SetHidden(false)

        local textStartTime = ZO_FormatTime(timeUntilNextReward, TIME_FORMAT_STYLE_COLONS, TIME_FORMAT_PRECISION_SECONDS)

        self.premiumRewardTimerControl:SetText(GAFE.Loc("NextReward") .. " " .. textStartTime)
    else
        self.premiumRewardTimerControl:SetHidden(true)
    end
end

function GAFE_ActivityFinderExtender:CheckMissingQuests()
    local function checkFunc(_obj_)
        local obj = _obj_

        return obj.gafeQuest and obj.node.data:GetActivityType() == self.dungeonDifficulty
    end

    self:RefreshDungeonDifficulty()
    self:CheckAllWhere(checkFunc)
end

function GAFE_ActivityFinderExtender:CheckMissingSets()
    local function checkFunc(_obj_)
        local obj = _obj_

        return obj.gafeSets and obj.node.data:GetActivityType() == self.dungeonDifficulty
    end

    self:RefreshDungeonDifficulty()
    self:CheckAllWhere(checkFunc)
end

function GAFE_ActivityFinderExtender:CheckAllWhere(_checkFunc_)
    local checkFunc = _checkFunc_

    local m_active = self.pool.m_Active
    for k, obj in pairs(m_active) do
        if checkFunc(obj) and obj.check:GetState() == 0 then
            ZO_CheckButton_OnClicked(obj.check)
            ZO_ACTIVITY_FINDER_ROOT_MANAGER:ToggleLocationSelected(obj.node.data)
        elseif (not checkFunc(obj)) and obj.check:GetState() ~= 0 then
            ZO_CheckButton_OnClicked(obj.check)
            ZO_ACTIVITY_FINDER_ROOT_MANAGER:ToggleLocationSelected(obj.node.data)
        end
    end
end

function GAFE_ActivityFinderExtender:RefreshDungeonDifficulty()
    local savedVars = GAFE.SavedVars
    self.dungeonDifficulty = savedVars.collapse == GAFE_COLLAPSE_MODE.Group and
        (ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and LFG_ACTIVITY_DUNGEON or LFG_ACTIVITY_MASTER_DUNGEON) -- Normal => 2, Veteran => 3
        or (savedVars.collapse == GAFE_COLLAPSE_MODE.Normal and LFG_ACTIVITY_DUNGEON or LFG_ACTIVITY_MASTER_DUNGEON)
end

function GAFE_ActivityFinderExtender.GetTimeUntilNextReward(characterId, rewardsVars)
    local result = 0
    local completedTimeStamp = rewardsVars.randomRewards[characterId]

    if completedTimeStamp then
        result = completedTimeStamp + 72000 - GetTimeStamp() -- 72000 = 20 hours
    end

    return result
end
