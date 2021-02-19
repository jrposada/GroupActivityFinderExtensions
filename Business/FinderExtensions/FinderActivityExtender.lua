local GAFE = GroupActivityFinderExtensions

FinderActivityExtender = {}
FinderActivityExtender.__index = FinderActivityExtender

local function GetTextureSize()
    local savedVars = GAFE.SavedVars
    return savedVars.textureSize
end

function FinderActivityExtender:New(finderName, prefix)
    local result = {}
    setmetatable(result, FinderActivityExtender)
    result.finderName = finderName
    result.prefix = prefix
    return result
end

function FinderActivityExtender:ExtendFunc(extendFunc, refreshFunc)
    local function result()
        -- Get player difficulty mode
        local difficultyMode = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 3 or 2 -- Normal => 2, Veteran => 3
        local characterId = GetCurrentCharacterId()

        for c = 2, 3 do
            local parent = _G[self.prefix.."_"..self.finderName.."Finder_KeyboardListSectionScrollChildContainer"..c]
            if parent then
                for i=1,parent:GetNumChildren() do
                    local obj=parent:GetChild(i)
                    if obj then
                        extendFunc(obj, c, i, characterId)
                    end
                end
            end

            -- Collapse corresponding panel depending on dungeon mode
            local header=_G[self.prefix.."_"..self.finderName.."Finder_KeyboardListSectionScrollChildZO_ActivityFinderTemplateNavigationHeader_Keyboard"..c-1]
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
        local parent = _G[self.prefix.."_"..self.finderName.."Finder_KeyboardListSectionScrollChildContainer"..c]
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
    local textureSize = GetTextureSize()
    local text
    if achievementId then
        text=IsAchievementComplete(achievementId) and self:FormatTexture(texture) or ""
    elseif debug and achievementId == nil then
        text=suffix[1]
    end
    return GAFE.UI.Label(GAFE.name.."_"..self.finderName.."Info_Achievements_"..suffix, parent, {textureSize,textureSize}, {LEFT,parent,LEFT,xOffset,0}, "ZoFontGameLarge", nil, {0,1}, text)
end

function FinderActivityExtender:AddQuest(questId, suffix, parent, texture, xOffset, debug)
    local textureSize = GetTextureSize()
    local text
    if questId then
        text=(GetCompletedQuestInfo(questId) ~= "" and true or false) and self:FormatTexture(texture) or ""
    elseif debug and questId == nil then
        text=suffix[1]
    end
    return GAFE.UI.Label(GAFE.name.."_"..self.finderName.."Info_Quest_"..suffix, parent, {textureSize,textureSize}, {LEFT,parent,LEFT,xOffset,0}, "ZoFontGameLarge", nil, {0,1}, text)
end

function FinderActivityExtender:AddLabel(text, suffix, parent, xOffset, width)
    local textureSize = GetTextureSize()
    if width == nil then width = textureSize end
    return GAFE.UI.Label(GAFE.name.."_"..self.finderName.."Info_"..suffix, parent, {width,textureSize}, {LEFT,parent,LEFT,xOffset,0}, "ZoFontGameLarge", nil, {0,1}, text)
end

function FinderActivityExtender:IsAnythingSelected()
	local isAnythingSelected = false
	for c=2,3 do
		local parent=_G[self.prefix.."_"..self.finderName.."Finder_KeyboardListSectionScrollChildContainer"..c]
		if parent then
			for i=1,parent:GetNumChildren() do
				local obj=parent:GetChild(i)
				if obj then
					isAnythingSelected = isAnythingSelected or obj.check:GetState()==BSTATE_PRESSED
				end
			end
		end
	end
	return isAnythingSelected
end

function FinderActivityExtender:GetSelecteds()
    local selected = {}
    local count = 0
    for c=2,3 do
		local parent=_G[self.prefix.."_"..self.finderName.."Finder_KeyboardListSectionScrollChildContainer"..c]
		if parent then
			for i=1,parent:GetNumChildren() do
				local obj=parent:GetChild(i)
				if obj and obj.check:GetState()==BSTATE_PRESSED then
					local activityId = obj.node.data.id
                    count = count + 1
                    selected[count] = activityId
				end
			end
		end
	end
    return selected, count
end

function FinderActivityExtender:FormatTexture(texture)
    local size = GetTextureSize()
    return "|t"..size..":"..size..":"..texture.."|t"
end