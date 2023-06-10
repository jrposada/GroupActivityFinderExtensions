---@diagnostic disable: undefined-global

local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER

GAFE.Debug = {}

function GAFE.Debug.LogControlShown()
	local num = GuiRoot:GetNumChildren()
	for i = 1, num, 1 do
	    local child = GuiRoot:GetChild(i)
	    if child then
	        local control = _G[child:GetName()]
	        if control then
	            ZO_PreHookHandler(_G[control:GetName()], 'OnEffectivelyShown', function() GAFE.LogLater(GetTimeStamp().." "..control:GetName().." shown") end)
	        end
	    end
	end
end

function GAFE.Debug.LogControlChilds(parent)
    local function Log()
        GAFE.LogLater(parent:GetName().." childs: "..parent:GetNumChildren())
        local num = parent:GetNumChildren()
        for i = 1, num, 1 do
            local child = parent:GetChild(i)
            if child then
                local control = _G[child:GetName()]
                if control then
                    GAFE.LogLater(" -> "..child:GetName())
                end
            end
        end
    end

    ZO_PreHookHandler(parent, 'OnEffectivelyShown', function() Log() end)
end

function GAFE.Debug.LogControlChildsText(parent)
    local function Log()
        GAFE.LogLater(parent:GetName().." childs: "..parent:GetNumChildren())
        local num = parent:GetNumChildren()
        for i = 1, num, 1 do
            local child = parent:GetChild(i)
            if child then
                local control = _G[child:GetName()]
                if control then
                    if control.GetText ~= nil then
                        GAFE.LogLater("-> "..child:GetText())
                    else
                        GAFE.LogLater("-> ".."nil")
                    end
                end
            end
        end
    end

    ZO_PreHookHandler(parent, 'OnEffectivelyShown', function() Log() end)
end

function GAFE.Debug.LogTable(table)
    for key, value in pairs(table) do
        GAFE.LogLater(key..": "..value)
    end
end

function GAFE.Debug.ExtractLocationsData()
    GAFE.SavedVars.LFG_ACTIVITY_BATTLE_GROUND_CHAMPION_Value = LFG_ACTIVITY_BATTLE_GROUND_CHAMPION
    GAFE.SavedVars.LFG_ACTIVITY_BATTLE_GROUND_LOW_LEVEL_Value = LFG_ACTIVITY_BATTLE_GROUND_LOW_LEVEL
    GAFE.SavedVars.LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION_Value = LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION
    GAFE.SavedVars.LFG_ACTIVITY_DUNGEON_Value = LFG_ACTIVITY_DUNGEON
    GAFE.SavedVars.LFG_ACTIVITY_MASTER_DUNGEON_Value = LFG_ACTIVITY_MASTER_DUNGEON
    GAFE.SavedVars.LFG_ACTIVITY_TRIAL_Value = LFG_ACTIVITY_TRIAL

    GAFE.SavedVars.LFG_ACTIVITY_BATTLE_GROUND_CHAMPION = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[LFG_ACTIVITY_BATTLE_GROUND_CHAMPION]
    GAFE.SavedVars.LFG_ACTIVITY_BATTLE_GROUND_LOW_LEVEL = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[LFG_ACTIVITY_BATTLE_GROUND_LOW_LEVEL]
    GAFE.SavedVars.LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[LFG_ACTIVITY_BATTLE_GROUND_NON_CHAMPION]
    GAFE.SavedVars.LFG_ACTIVITY_DUNGEON = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[LFG_ACTIVITY_DUNGEON]
    GAFE.SavedVars.LFG_ACTIVITY_MASTER_DUNGEON = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[LFG_ACTIVITY_MASTER_DUNGEON]
    GAFE.SavedVars.LFG_ACTIVITY_TRIAL = ZO_ACTIVITY_FINDER_ROOT_MANAGER.sortedLocationsData[LFG_ACTIVITY_TRIAL]
end

function GAFE.Debug.ExtractActivitiesInfo()
    local info = {}
    for activityId = 1, 1000 do
        -- ** _Returns:_ *string* _name_, *integer* _levelMin_, *integer* _levelMax_, *integer* _championPointsMin_, *integer* _championPointsMax_, *[LFGGroupType|#LFGGroupType]* _groupType_, *integer* _minGroupSize_, *string* _description_, *integer* _sortOrder_
        info[activityId] = { GetActivityInfo(activityId) }
    end

    GAFE.SavedVars.ActivitiesInfo = info
end

function GAFE.Debug.LogNodeIds()
    for id=1, GetNumFastTravelNodes() do
        local _, name = GetFastTravelNodeInfo(id)
        GAFE.LogLater(id.."-"..name)
    end
end

function GAFE.Debug.SetIds()
    GAFE.LogLater('Debuging Sets, right click in collection set to log id')

    local function DebugLog(control, button, upInside)
        local headerData = control.dataEntry.data.header
        local setId = headerData:GetId()
        local setCollectionData = ITEM_SET_COLLECTIONS_DATA_MANAGER:GetItemSetCollectionData(setId)
        GAFE.LogLater(setCollectionData:GetRawName().." = "..setId)
    end

    ZO_PreHook("ZO_ItemSetsBook_Entry_Header_Keyboard_OnMouseUp", function(control, button, upInside) DebugLog(control) end)
end

function GAFE.Debug.AchievementIds()
    GAFE.LogLater('Debuging Achievement, right click in an achievement to log id')

    local original = Achievement.ToggleCollapse
    Achievement.ToggleCollapse = function (self, button)
        original(self, button)
        local name = GetAchievementInfo(self.achievementId)
        GAFE.LogLater(name.." = "..self.achievementId)
    end
end

function GAFE.Debug.DebugQuests()
    GAFE.LogLater('Debuging Quests')

    local function LogQuest(_, isCompleted, _, questName, _, _, questId)
        GAFE.LogLater(questName.." = "..questId)
    end

    EM:RegisterForEvent(GAFE.name.."_QuestRemoved_Debug", EVENT_QUEST_REMOVED, LogQuest)
end
