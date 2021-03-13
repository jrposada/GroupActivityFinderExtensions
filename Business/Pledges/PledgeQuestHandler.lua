local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER
local PledgeChatterOptions = GAFE.PledgeChatterOptions

GAFE.PledgeQuestHandler = {}

local questOfferedEventName = GAFE.name.."QuestOffered"
local questOffered = false

local function HandleChatterBegin(eventCode, optionCount)

	local function HandleEventQuestOffered(_)
		if questOffered then
			EM:UnregisterForEvent(questOfferedEventName, EVENT_QUEST_OFFERED)
		end

		questOffered = true
		AcceptOfferedQuest()
	end

	local function IsPledgeQuestOption(optionString)
		local isPledgeQuestOption = false

		for _, option in ipairs(PledgeChatterOptions) do
			if optionString == option then
				isPledgeQuestOption = true
				break
			end
		end

		return isPledgeQuestOption
	end

	if questOffered then
		questOffered = false
		EndInteraction(INTERACTION_CONVERSATION)
	end

	if optionCount ~= 0 then
		for optionIndex = 1, optionCount do
			local optionString, optionType = GetChatterOption(optionIndex)
			local isPledgeQuestOption = IsPledgeQuestOption(optionString)

			if optionType == CHATTER_START_NEW_QUEST_BESTOWAL and isPledgeQuestOption then
				questOffered = false
				EM:RegisterForEvent(questOfferedEventName, EVENT_QUEST_OFFERED, HandleEventQuestOffered)
				SelectChatterOption(optionIndex)
			elseif optionType == CHATTER_START_COMPLETE_QUEST then
				--
				-- GAFE.LogLater("hey")
			end
		end
	end
end

function GAFE.PledgeQuestHandler.Init()
	local savedVars = GAFE.SavedVars
	GAFE.PledgeQuestHandler.Enable(savedVars.dungeons.handlePledgeQuest)
end

function GAFE.PledgeQuestHandler.Enable(enabled)
	local savedVars = GAFE.SavedVars
	savedVars.dungeons.handlePledgeQuest = enabled

	local eventName = GAFE.name.."PledgeQuest"
	if enabled then
		EM:RegisterForEvent(eventName, EVENT_CHATTER_BEGIN, HandleChatterBegin)
	else
		EM:UnregisterForEvent(eventName)
		GAFE.LogLater("mmm")
	end
end

local function HandleChatterBegin(eventCode, optionCount)

	
    -- Ignore interactions with no options
    if optionCount == 0 then return end

    for i = 1, optionCount do
	    -- Get details of first option

	    local optionString, optionType = GetChatterOption(i)

	    -- If it is a writ quest option...
	    if optionType == CHATTER_START_NEW_QUEST_BESTOWAL 
	       and string.find(string.lower(optionString), string.lower(WritCreater.writNames["G"])) ~= nil 
	    then
	    	if not WritCreater:GetSettings().autoAccept then return end
	    	if isQuestTypeActive(optionString) then
				-- Listen for the quest offering
				EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_OFFERED, HandleEventQuestOffered)
				-- Select the first writ
				SelectChatterOption(i)
				return
			else
				if i == optionCount and wasQuestAccepted then
					EndInteraction( INTERACTION_CONVERSATION)
					wasQuestAccepted = nil
				end
			end
			
	    -- If it is a writ quest completion option
	    elseif optionType == CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS
	       and string.find(string.lower(optionString), string.lower(completionStrings.place)) ~= nil  
	    then
	    	if not WritCreater:GetSettings().autoAccept then return end
	        -- Listen for the quest complete dialog
	        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
	        -- Select the first option to complete the quest
	        SelectChatterOption(1)
	        return
	    
	    -- If the goods were already placed, then complete the quest
	    elseif optionType == CHATTER_START_COMPLETE_QUEST
	       and (string.find(string.lower(optionString), string.lower(completionStrings.place)) ~= nil 
	            or string.find(string.lower(optionString), string.lower(completionStrings.sign)) ~= nil)
	    then
	    	if not WritCreater:GetSettings().autoAccept then return end
	        -- Listen for the quest complete dialog
	        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
	        -- Select the first option to place goods and/or sign the manifest
	        SelectChatterOption(1)
	        return
	        -- Talking to the master writ person?
	    elseif zo_plainstrfind( ZO_InteractWindowTargetAreaTitle:GetText() ,completionStrings["Rolis Hlaalu"]) then 
	    	if not WritCreater:GetSettings().autoAccept then return end
	    	--d(optionType)
	    	--d(optionString)
		    if optionType == CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS
		       and string.find(string.lower(optionString), string.lower(completionStrings.masterPlace)) ~= nil  
		    then
		        -- Listen for the quest complete dialog
		        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
		        -- Select the first option to complete the quest
		        --d("Chat")
		        SelectChatterOption(1)
		        return
		        -- If the goods were already placed, then complete the quest
		    elseif optionType == CHATTER_START_COMPLETE_QUEST
		       and (string.find(string.lower(optionString), string.lower(completionStrings.masterPlace)) ~= nil 
		            or string.find(string.lower(optionString), string.lower(completionStrings.masterSign)) ~= nil)
		    then
		        -- Listen for the quest complete dialog
		        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
		        -- Select the first option to place goods and/or sign the manifest
		        --d("Chat2")
		        SelectChatterOption(1)
		        return
		    end
		elseif optionType == CHATTER_START_BANK then
			if WritCreater:GetSettings().autoCloseBank then
				WritCreater.alchGrab()
			end
	    end
	end
end