local GAFE = GroupActivityFinderExtensions
local EM = EVENT_MANAGER


RandomActivityExtender = {}
RandomActivityExtender.__index = RandomActivityExtender


function RandomActivityExtender:New(name, parentName, rewardsVars)
    local result = {}
    setmetatable(result, RandomActivityExtender)
    self.name = "GAFE_"..name
    self.parent = _G[parentName.."SingularSectionRewardsSectionHeader"]
    result.rewardsVars = rewardsVars
    return result
end

function RandomActivityExtender:Init()
    -- Initialize control.
    self.control = GAFE.UI.Label(self.name.."_Control", self.parent, {125,20}, {TOPLEFT,self.parent,TOPRIGHT,10,2}, "ZoFontGameShadow", nil, {0,1})

    -- Initialize handlers.
    local function OnShown()
        local function Update()
            self:UpdatePurpleRewardTimer()
        end

        self:UpdatePurpleRewardTimer()
        EM:RegisterForUpdate(self.name.."_Control_Update", 1000, Update)
    end

    ZO_PreHookHandler(self.parent, 'OnEffectivelyShown', OnShown)
	ZO_PreHookHandler(self.parent, 'OnEffectivelyHidden', function() EM:UnregisterForUpdate(self.name.."_Control_Update") end)
end

function RandomActivityExtender:UpdatePurpleRewardTimer()
    local characterId = GetCurrentCharacterId()
	local timeUntilNextReward = self:GetTimeUntilNextReward(characterId)
    if timeUntilNextReward > 0 then
        self.control:SetHidden(false)

        local textStartTime = ZO_FormatTime(timeUntilNextReward, TIME_FORMAT_STYLE_COLONS, TIME_FORMAT_PRECISION_SECONDS)

        self.control:SetText(GAFE.Loc("NextReward").." "..textStartTime)
    else
        self.control:SetHidden(true)
    end
end

-- Returns time in milliseconds until next reward. It's in a 20 hours cooldown.
function RandomActivityExtender:GetTimeUntilNextReward(characterId)
    local result = 0
    local completedTimeStamp = self.rewardsVars.randomRewards[characterId]

    if completedTimeStamp then
        result = completedTimeStamp + 72000 - GetTimeStamp() -- 72000 = 20 hours
    end

    return result
end

