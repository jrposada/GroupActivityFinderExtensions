local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER

GAFE.RandomDungeon = {}

local purpleRewardTimerLabel

local function UpdatePurpleRewardTimer()
    local characterId = GetCurrentCharacterId()
	local timeUntilNextReward = GAFE.RandomDungeon.GetTimeUntilNextReward(characterId)
    if timeUntilNextReward > 0 then
        purpleRewardTimerLabel:SetHidden(false)

        local textStartTime = ZO_FormatTime(timeUntilNextReward, TIME_FORMAT_STYLE_COLONS, TIME_FORMAT_PRECISION_SECONDS)

        purpleRewardTimerLabel:SetText(GAFE.Loc("DungeonFinderNextReward").." "..textStartTime)
    else
        purpleRewardTimerLabel:SetHidden(true)
    end
end

local function OnActivityFinderStatusUpdate(_, status)
    if status == ACTIVITY_FINDER_STATUS_COMPLETE then
        local characterId = GetCurrentCharacterId()
        GAFE.SavedVars.dungeons.randomRewards[characterId] = GetTimeStamp()
    end
end

function GAFE.RandomDungeon.Init()
	-- Next purple reward timer
	local rewardsSectionHeader = ZO_DungeonFinder_KeyboardSingularSectionRewardsSectionHeader
	purpleRewardTimerLabel = GAFE.UI.Label("GAFE_PurpleRewardTimer", rewardsSectionHeader, {125,20}, {TOPLEFT,rewardsSectionHeader,TOPRIGHT,10,2}, "ZoFontGameShadow", nil, {0,1})

    ZO_PreHookHandler(rewardsSectionHeader, 'OnEffectivelyShown', function() 
        UpdatePurpleRewardTimer()
        EM:RegisterForUpdate("GAFE_PurpleRewardTimer_Update", 1000, UpdatePurpleRewardTimer)
    end)
	ZO_PreHookHandler(rewardsSectionHeader, 'OnEffectivelyHidden', function() EM:UnregisterForUpdate("GAFE_PurpleRewardTimer_Update") end)

    EM:RegisterForEvent("GAFE_ActivityStatus_Update", EVENT_ACTIVITY_FINDER_STATUS_UPDATE, OnActivityFinderStatusUpdate)
end

function GAFE.RandomDungeon.GetTimeUntilNextReward(characterId, questId)
    local result = 0

    if GAFE.SavedVars.dungeons.randomRewards ~= nil then
        local completedTimeStamp = GAFE.SavedVars.dungeons.randomRewards[characterId]
        if completedTimeStamp then
            result = completedTimeStamp + 72000 - GetTimeStamp() -- 72000 = 20 hours
        end
    end

    return result
end