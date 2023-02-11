local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER
local TrialActivityData = GAFE.TrialActivityData

GAFE.TrialFinder = {}

local finderActivityExtender = FinderActivityExtender:New("Trial", "GAFE")
local lfgButton
local lfmButton
local counterTs
local counterHs
local counterDds
local counterModifiers

--------
-- LF --
--------
local function Lfg()
    local selected = finderActivityExtender:GetSelecteds()
    GAFE.QueueManager.Lfg(selected)
end

local function Lfm()
    local selected = finderActivityExtender:GetSelecteds()
    GAFE.QueueManager.Lfm(selected)
end

local function CanLfg(isAnythingSelected)
    return isAnythingSelected and GetGroupSize() == 0
end

local function CanLfm(isAnythingSelected)
    if isAnythingSelected then
        local _, count = finderActivityExtender:GetSelecteds()
        return count == 1 and (GetGroupSize() == 0 or IsUnitGroupLeader("player"))
    end
    return false
end

local function UpdateTargetTank(value)
    GAFE.QueueManager.SetRoleTarget(LFG_ROLE_TANK, value)
end

local function UpdateTargetHeal(value)
    GAFE.QueueManager.SetRoleTarget(LFG_ROLE_HEAL, value)
end

local function UpdateTargetDd(value)
    GAFE.QueueManager.SetRoleTarget(LFG_ROLE_DPS, value)
end

local function UpdateTargetModifiers(value)
    GAFE.QueueManager.SetModifiersTarget(value)
end

-------------
-- General --
-------------
local function RefreshControlsVisibility(canLfm)
    local tabHidden = GAFE_TrialFinder_KeyboardListSection:IsHidden()

    if lfgButton then
        lfgButton:SetHidden(tabHidden)
    end

    if lfmButton then
        lfmButton:SetHidden(tabHidden)
    end

    if counterTs then
        counterTs:SetHidden((not canLfm) or tabHidden)
    end

    if counterHs then
        counterHs:SetHidden((not canLfm) or tabHidden)
    end

    if counterDds then
        counterDds:SetHidden((not canLfm) or tabHidden)
    end

    if counterModifiers then
        counterModifiers:SetHidden((not canLfm) or tabHidden)
    end
end

local function RefreshControls()
    local isAnythingSelected = finderActivityExtender:IsAnythingSelected()

    if lfgButton then
        local tooltipText = nil
        local canLfg = CanLfg(isAnythingSelected)
        if not canLfg then
            tooltipText = GAFE.Loc("LookForGroupDisabled")
        end
        lfgButton:SetState(canLfg and BSTATE_NORMAL or BSTATE_DISABLED)
        GAFE.UI.SetTooltip(lfgButton, tooltipText)
    end

    local canLfm = CanLfm(isAnythingSelected)
    if lfmButton then
        local tooltipText = nil
        if isAnythingSelected and (not canLfm) then
            tooltipText = GAFE.Loc("LookForMoreDisabled")
        end
        lfmButton:SetState(canLfm and BSTATE_NORMAL or BSTATE_DISABLED)
        GAFE.UI.SetTooltip(lfgButton, tooltipText)
    end

    RefreshControlsVisibility(canLfm)

    GAFE.QueueManager.RefreshControls()
end

local function OnShown()
    local canLfg = CanLfg(false)
    RefreshControlsVisibility(canLfg)
    GAFE.CallLater("ExtendTrialActivity", 200, function()
        RefreshControls()
        finderActivityExtender:AutoCollapse()
    end)
end

local function OnHidden()
    local canLfg = CanLfg(false)
    RefreshControlsVisibility(canLfg)
end

function GAFE.TrialFinder.Init()
    -- Panel buttons
    local parent = GAFE_TrialFinder_Keyboard
    if parent then
        -- Create lf buttons
        local perfectPixel = GAFE.SavedVars.compatibility.perfectPixel
        local dims = { 200, 28 }
        local canLfg = CanLfg()
        local canLfm = CanLfm()

        if perfectPixel then
            parent = ZO_SearchingForGroup
            local w = parent:GetWidth()

            lfgButton = GAFE.UI.ZOButton("GAFE_LookForGroup", parent, dims, { BOTTOM, parent, BOTTOM, 0, -76 }, GAFE.Loc("LookForGroup"), Lfg, canLfg)
            lfmButton = GAFE.UI.ZOButton("GAFE_LookForMore", parent, dims, { BOTTOM, parent, BOTTOM, 0, -112 }, GAFE.Loc("LookForMore"), Lfm, canLfm)

            -- Create party composition controls
            dims = { 60, 36 }
            counterTs = GAFE.UI.Counter(GAFE.name .. "_Group_ts", parent, dims, { BOTTOM, parent, BOTTOM, -w / 2, 0 }, nil, GAFE.QueueManager.GetRoleText(LFG_ROLE_TANK), GAFE.QueueManager.GetRoleTarget(LFG_ROLE_TANK), UpdateTargetTank, not canLfm)
            counterHs = GAFE.UI.Counter(GAFE.name .. "_Group_hl", parent, dims, { BOTTOM, parent, BOTTOM, -w / 6, 0 }, nil, GAFE.QueueManager.GetRoleText(LFG_ROLE_HEAL), GAFE.QueueManager.GetRoleTarget(LFG_ROLE_HEAL), UpdateTargetHeal, not canLfm)
            counterDds = GAFE.UI.Counter(GAFE.name .. "_Group_dds", parent, dims, { BOTTOM, parent, BOTTOM, w / 6, 0 }, nil, GAFE.QueueManager.GetRoleText(LFG_ROLE_DPS), GAFE.QueueManager.GetRoleTarget(LFG_ROLE_DPS), UpdateTargetDd, not canLfm)
            counterModifiers = GAFE.UI.Counter(GAFE.name .. "_Group_mods", parent, dims, { BOTTOM, parent, BOTTOM, w / 2, 0 }, nil, 'Mod', 0, UpdateTargetModifiers, not canLfm)

            ZO_SearchingForGroupStatus:ClearAnchors()
            ZO_SearchingForGroupStatus:SetAnchor(BOTTOM, parent, BOTTOM, 0, -148)
            ZO_SearchingForGroupStatus:SetDrawTier(2)

            -- Hide queue button.
            local queueButton = GAFE_TrialFinder_KeyboardQueueButton
            queueButton:SetHidden(true)
        else
            local w = parent:GetWidth()
            lfgButton = GAFE.UI.ZOButton("GAFE_LookForGroup", parent, dims, { BOTTOM, parent, BOTTOM, w / 3, 0 }, GAFE.Loc("LookForGroup"), Lfg, canLfg)
            lfmButton = GAFE.UI.ZOButton("GAFE_LookForMore", parent, dims, { BOTTOM, parent, BOTTOM, -w / 3, 0 }, GAFE.Loc("LookForMore"), Lfm, canLfm)

            -- Create party composition controls
            dims = { 65, 40 }
            counterTs = GAFE.UI.Counter(GAFE.name .. "_Group_ts", parent, dims, { BOTTOM, parent, BOTTOM, -w / 3, -35 }, nil, GAFE.QueueManager.GetRoleText(LFG_ROLE_TANK), GAFE.QueueManager.GetRoleTarget(LFG_ROLE_TANK), UpdateTargetTank, not canLfm)
            counterHs = GAFE.UI.Counter(GAFE.name .. "_Group_hl", parent, dims, { BOTTOM, parent, BOTTOM, -w / 9, -35 }, nil, GAFE.QueueManager.GetRoleText(LFG_ROLE_HEAL), GAFE.QueueManager.GetRoleTarget(LFG_ROLE_HEAL), UpdateTargetHeal, not canLfm)
            counterDds = GAFE.UI.Counter(GAFE.name .. "_Group_dds", parent, dims, { BOTTOM, parent, BOTTOM, w / 9, -35 }, nil, GAFE.QueueManager.GetRoleText(LFG_ROLE_DPS), GAFE.QueueManager.GetRoleTarget(LFG_ROLE_DPS), UpdateTargetDd, not canLfm)
            counterModifiers = GAFE.UI.Counter(GAFE.name .. "_Group_mods", parent, dims, { BOTTOM, parent, BOTTOM, w / 3, -35 }, nil, 'Mod', 0, UpdateTargetModifiers, not canLfm)

            -- Hide queue button.
            local queueButton = GAFE_TrialFinder_KeyboardQueueButton
            queueButton:SetHidden(true)
        end

        RefreshControls()
    end

    -- Entry extensions
    local treeEntry = TRIAL_FINDER_KEYBOARD.navigationTree.templateInfo.ZO_ActivityFinderTemplateNavigationEntry_Keyboard
    local baseEntrySetupFunction = treeEntry.setupFunction
    treeEntry.setupFunction = function(node, control, data, open)
        baseEntrySetupFunction(node, control, data, open)

        control:SetHandler("OnMouseUp", function() RefreshControls() end, GAFE.name)
    end

    ZO_PreHookHandler(GAFE_TrialFinder_KeyboardListSection, 'OnEffectivelyShown', OnShown)
    ZO_PreHookHandler(GAFE_TrialFinder_KeyboardListSection, 'OnEffectivelyHidden', OnHidden)

    EM:RegisterForEvent(GAFE.name .. "_GroupMemberJoined", EVENT_GROUP_MEMBER_JOINED, RefreshControls)
    EM:RegisterForEvent(GAFE.name .. "_GroupMemberLeft", EVENT_GROUP_MEMBER_LEFT, RefreshControls)
    EM:RegisterForEvent(GAFE.name .. "_LeaderUpdated", EVENT_LEADER_UPDATE, RefreshControls)
end
