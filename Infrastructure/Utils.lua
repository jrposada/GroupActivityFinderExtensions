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
		-- TODO: We are still getting empty strings
		if match ~= " " then
			table.insert(result, match);
			numWords = numWords + 1
		end
	end
	return result, numWords;
end