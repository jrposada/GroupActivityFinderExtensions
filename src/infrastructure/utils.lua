local GAFE = GroupActivityFinderExtensions

function GAFE.CallLater(name,ms,func,opt1,opt2)
	if ms then
		EVENT_MANAGER:RegisterForUpdate("CallLater_"..name, ms,
		function()
			EVENT_MANAGER:UnregisterForUpdate("CallLater_"..name)
			func(opt1,opt2)
		end)
	else
		EVENT_MANAGER:UnregisterForUpdate("CallLater_"..name)
	end
end

function GAFE.LogLater(obj)
	zo_callLater(function() d(obj) end, 200)
end

function GAFE.ParseTimeStamp(timeStamp)
	local seconds = timeStamp

	local days = math.floor(seconds / 86400) -- 1 day
	seconds = seconds - (days * 86400)

	local hours = math.floor(seconds / 3600) -- 1 hour
	seconds = seconds - (hours * 3600)

	local mins = math.floor(seconds / 60) -- 1 min
	seconds = seconds - (mins * 60)

	return string.format("%01d %02d:%02d:%02d", days, hours, mins, seconds)
end

function GAFE.Split(text, delimiter)
	local result = {};
	local numWords = 0
	for match in (text..delimiter):gmatch("(.-)"..delimiter) do
		if match ~= "" then
			table.insert(result, match);
			numWords = numWords + 1
		end
	end
	return result, numWords;
end

function GAFE.ContainsKey(table, key)
	for tableKey, _ in pairs(table) do
		if tableKey == key then
			return true
		end
	end

	return false
end

function GAFE.ContainsValue(table, value)
	for _, tableValue in pairs(table) do
		if tableValue == value then
			return true
		end
	end

	return false
end

function GAFE.CleanPledgeQuestName(name)
    return string.format("%s", name:gsub(".*:%s*", ""))
end

-- https://forums.elderscrollsonline.com/en/discussion/629071/pc-mac-patch-notes-v8-3-5
-- 3am UTC for European servers and 10am UTC for North American servers
if GetWorldName() == 'EU Megaserver' then
    GAFE.baseResetTimesamp = 1517454000
else
    GAFE.baseResetTimesamp = 1517479200
end

function GAFE.GetDay(timestamp)
    return math.floor(GetDiffBetweenTimeStamps(timestamp or GetTimeStamp(), GAFE.baseResetTimesamp) / 86400) -- 86400 = 1 day
end
