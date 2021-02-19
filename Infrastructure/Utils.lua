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

function GAFE.Split(text, delimiter)
	local result = {};
	for match in (text..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match);
	end
	return result;
end