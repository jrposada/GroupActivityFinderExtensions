local GAFE = GroupActivityFinderExtensions

FinderActivityExtender = {}
FinderActivityExtender.__index = FinderActivityExtender

function FinderActivityExtender:New(finderName)
    local result = {}
    setmetatable(result, FinderActivityExtender)
    result.finderName = finderName
    return result
end

function FinderActivityExtender:ExtendFunc(extendFunc, refreshFunc)
    local function result()
        -- Get player difficulty mode
        local difficultyMode = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 3 or 2 -- Normal => 2, Veteran => 3

        for c = 2, 3 do
            local parent = _G["ZO_"..self.finderName.."Finder_KeyboardListSectionScrollChildContainer"..c]
            if parent then
                for i=1,parent:GetNumChildren() do
                    local obj=parent:GetChild(i)
                    if obj then
                        extendFunc(obj, c, i)
                    end
                end
            end

            -- Collapse corresponding panel depending on dungeon mode
            local header=_G["ZO_"..self.finderName.."Finder_KeyboardListSectionScrollChildZO_ActivityFinderTemplateNavigationHeader_Keyboard"..c-1]
            if header then
                local state=header.text:GetColor()
                if ((difficultyMode==c)==(state==1)) then header:OnMouseUp(true) end
            end
        end

        if refreshFunc then
            refreshFunc()
        end
    end
    return result
end

function FinderActivityExtender:CheckFunc(checkFunc)
    local function func()
        local c = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 2 or 3 -- Normal => 2, Veteran => 3
        local parent = _G["ZO_"..self.finderName.."Finder_KeyboardListSectionScrollChildContainer"..c]
        if parent then
            for i = 1, parent:GetNumChildren() do
                local obj = parent:GetChild(i)
                if obj and checkFunc(obj) and obj.check:GetState() == 0 then
                    obj.check:SetState(BSTATE_PRESSED, true)
                    ZO_ACTIVITY_FINDER_ROOT_MANAGER:ToggleLocationSelected(obj.node.data)
                end
            end
        end
    end
    return func
end

function FinderActivityExtender:AddAchievement(achievementId, suffix, parent, texture, xOffset, debug)
    local text
    if achievementId then
        text=IsAchievementComplete(achievementId) and "|t20:20:"..texture.."|t" or ""
    elseif debug and achievementId == nil then
        text=suffix[1]
    end
    GAFE.UI.Label(GAFE.name.."_"..self.finderName.."Info_Achievements_"..suffix, parent, {20,20}, {LEFT,parent,LEFT,xOffset,0}, "ZoFontGameLarge", nil, {0,1}, text)
end

function FinderActivityExtender:AddQuest(questId, suffix, parent, texture, xOffset, debug)
    local text
    if questId then
        text=(GetCompletedQuestInfo(questId) ~= "" and true or false) and "|t20:20:"..texture.."|t" or ""
    elseif debug and questId == nil then
        text=suffix[1]
    end
    GAFE.UI.Label(GAFE.name.."_"..self.finderName.."Info_Quest_"..suffix, parent, {20,20}, {LEFT,parent,LEFT,xOffset,0}, "ZoFontGameLarge", nil, {0,1}, text)
end