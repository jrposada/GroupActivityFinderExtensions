local GAFE = GroupActivityFinderExtensions
local TFD = GAFE.TrialFinderData

GAFE.TrialFinder = {}

-- https://esoitem.uesp.net/viewlog.php
local TrialData={
    --Normal
    [GAFE_TRIAL_ACTIVITY_ID.NormalAetherianArchive]     = { id=nil },
    [GAFE_TRIAL_ACTIVITY_ID.NormalHelRaCitadel]         = { id=nil },
    [GAFE_TRIAL_ACTIVITY_ID.NormalSanctumOphidia]       = { id=nil },
    [GAFE_TRIAL_ACTIVITY_ID.NormalMawOfLorkhaj]         = { id=nil },
    [GAFE_TRIAL_ACTIVITY_ID.NormalHallsOfFabrication]   = { id=nil },
    [GAFE_TRIAL_ACTIVITY_ID.NormalAsylumSanctorium]     = { id=nil },
    [GAFE_TRIAL_ACTIVITY_ID.NormalCloudrest]            = { id=nil },
    [GAFE_TRIAL_ACTIVITY_ID.NormalSunspire]             = { id=nil },
    [GAFE_TRIAL_ACTIVITY_ID.NormalKynesAegis]           = { id=nil },
    --Veteran
    [GAFE_TRIAL_ACTIVITY_ID.VeteranAetherianArchive]     = { id=nil,    hm=nil,    tt=nil,    nd=nil },
    [GAFE_TRIAL_ACTIVITY_ID.VeteranHelRaCitadel]         = { id=nil,    hm=nil,    tt=nil,    nd=nil },
    [GAFE_TRIAL_ACTIVITY_ID.VeteranSanctumOphidia]       = { id=nil,    hm=nil,    tt=nil,    nd=nil },
    [GAFE_TRIAL_ACTIVITY_ID.VeteranMawOfLorkhaj]         = { id=nil,    hm=nil,    tt=nil,    nd=nil },
    [GAFE_TRIAL_ACTIVITY_ID.VeteranHallsOfFabrication]   = { id=nil,    hm=nil,    tt=nil,    nd=nil },
    [GAFE_TRIAL_ACTIVITY_ID.VeteranAsylumSanctorium]     = { id=nil,    hm=nil,    tt=nil,    nd=nil },
    [GAFE_TRIAL_ACTIVITY_ID.VeteranCloudrest]            = { id=nil,    hm=nil,    tt=nil,    nd=nil },
    [GAFE_TRIAL_ACTIVITY_ID.VeteranSunspire]             = { id=nil,    hm=nil,    tt=nil,    nd=nil },
    [GAFE_TRIAL_ACTIVITY_ID.VeteranKynesAegis]           = { id=nil,    hm=nil,    tt=nil,    nd=nil }
}


-- local function GetGoalPledges()
--     local pledgeQuests, havePledge = {}, false
--     for i=1, MAX_JOURNAL_QUESTS do
--         local name,_,_,stepType,_,completed,_,_,_,questType,instanceType=GetJournalQuestInfo(i)
--         if name and name~="" and not completed and questType==QUEST_TYPE_UNDAUNTED_PLEDGE and instanceType==INSTANCE_TYPE_GROUP then
--             local text=string.format("%s",name:gsub(".*:%s*",""):gsub(" "," "):lower())
--             pledgeQuests[text]=stepType~=QUEST_STEP_TYPE_AND
--             if stepType==QUEST_STEP_TYPE_AND then havePledge=true end
-- 		end
--     end
--     return pledgeQuests, havePledge
-- end

local function TrialFinder()
    -- local pledgeQuests, havePledge, haveQuests={}, false, false
	-- local day=math.floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1517464800)/86400)

    local function Lfg()
        GAFE.LogLater("lfg")
		-- local c = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 2 or 3 -- Normal => 2, Veteran => 3
		-- local parent=_G["ZO_DungeonFinder_KeyboardListSectionScrollChildContainer"..c]
		-- if parent then
		-- 	for i=1,parent:GetNumChildren() do
		-- 		local obj=parent:GetChild(i)
		-- 		if obj and obj.pledge and obj.check:GetState()==0 then
		-- 			obj.check:SetState(BSTATE_PRESSED, true)
		-- 			ZO_ACTIVITY_FINDER_ROOT_MANAGER:ToggleLocationSelected(obj.node.data)
		-- 		end
		-- 	end
		-- end
	end

    local function Lfm()
        GAFE.LogLater("lfm")
		-- local c = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 2 or 3 -- Normal => 2, Veteran => 3
		-- local parent=_G["ZO_DungeonFinder_KeyboardListSectionScrollChildContainer"..c]
		-- if parent then
		-- 	for i=1,parent:GetNumChildren() do
		-- 		local obj=parent:GetChild(i)
		-- 		if obj and obj.quest and obj.check:GetState()==0 then
		-- 			obj.check:SetState(BSTATE_PRESSED, true)
		-- 			ZO_ACTIVITY_FINDER_ROOT_MANAGER:ToggleLocationSelected(obj.node.data)
		-- 		end
		-- 	end
		-- end
	end

	local function AddTrialElements()
		-- Get player difficulty mode
		local difficultyMode = ZO_GetEffectiveDungeonDifficulty() == DUNGEON_DIFFICULTY_NORMAL and 3 or 2 -- Normal => 2, Veteran => 3

		for c=2,3 do
			local parent=_G["GAFE_TrialFinder_KeyboardListSectionScrollChildContainer"..c]
			if parent then
				for i=1,parent:GetNumChildren() do
					local obj=parent:GetChild(i)
					if obj then
						local id=obj.node.data.id
                        if TrialData[id] then
                            local debug = GetDisplayName() == "@Panicida"

                            
							local weeklyLabel = GAFE.UI.Label(GAFE.name.."_TrialInfo_Weekly"..c..i, obj, {125,20}, {LEFT,obj,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, "")

							local achivementText=""

							-- General Vanquisher (normal) / Conqueror (veteran)
							if TrialData[id].id then
								achivementText=achivementText..(IsAchievementComplete(TrialData[id].id) and "|t20:20:/esoui/art/announcewindow/announcement_icon_up.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."i"
							end

							-- Death challenge (hard mode)
							if TrialData[id].hm then
								achivementText=achivementText..(IsAchievementComplete(TrialData[id].hm) and "|t20:20:/esoui/art/unitframes/target_veteranrank_icon.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."h"
							end

							-- Speed challenge
							if TrialData[id].tt then
								achivementText=achivementText..(IsAchievementComplete(TrialData[id].tt) and "|t20:20:/esoui/art/ava/overview_icon_underdog_score.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."t"
							end

							-- Survivor challenge (no death)
							if TrialData[id].nd then
								achivementText=achivementText..(IsAchievementComplete(TrialData[id].nd) and "|t20:20:/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_death.dds|t" or "")
							elseif c~=2 and debug then
								achivementText=achivementText.."n"
                            end

							local achievementsLabel = GAFE.UI.Label(GAFE.name.."_TrialInfo_Achievements"..c..i, weeklyLabel, {105,20}, {RIGHT,weeklyLabel,RIGHT,0,0}, "ZoFontGameLarge", nil, {0,1}, achivementText)

							-- Quest
							-- obj.quest = GetCompletedQuestInfo(TrialData[id].q) == "" and true or false
							-- haveQuests = haveQuests or obj.quest
						else
							local todo = GAFE.UI.Label(GAFE.name.."_TrialInfo"..c..i, obj, {125,20}, {LEFT,obj,LEFT,420,0}, "ZoFontGameLarge", nil, {0,1}, "TODO:"..id)
						end
					end
				end
			end

			-- Collapse corresponding panel depending on dungeon mode
			local header=_G["GAFE_TrialFinder_KeyboardListSectionScrollChildZO_ActivityFinderTemplateNavigationHeader_Keyboard"..c-1]
			if header then
				local state=header.text:GetColor()
				if ((difficultyMode==c)==(state==1)) then header:OnMouseUp(true) end
			end
        end

        -- Add buttons
        local parent=GAFE_TrialFinder_Keyboard
        if parent then
            local w=parent:GetWidth()
            local dims = {200,28}

            local lfgButton=GAFE.UI.Button("GAFE_LookForGroup", parent, dims, {BOTTOM,parent,BOTTOM,w/3,0}, GAFE.Loc("LookForGroup"), Lfg, true, GAFE.Loc("LookForGroupTooltip"))
            local lfmButton=GAFE.UI.Button("GAFE_LookForMore", parent, dims, {BOTTOM,parent,BOTTOM,0,0}, GAFE.Loc("LookForMore"), Lfm, true, GAFE.Loc("LookForMoreTooltip"))
        end
	end

    -- Hide queue button.
    local queueButton = GAFE_TrialFinder_KeyboardQueueButton
    if queueButton then
        queueButton:SetHidden(true)
    end

    ZO_PreHookHandler(GAFE_TrialFinder_KeyboardListSection, 'OnEffectivelyShown', function() GAFE.CallLater("AddTrialElements",200,AddTrialElements) end)
	-- ZO_PreHookHandler(ZO_TrialFinder_KeyboardListSection, 'OnEffectivelyHidden', function()  end)
end

function GAFE.TrialFinder.Init()
	TrialFinder()
end