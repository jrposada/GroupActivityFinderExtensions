local GAFE = GroupActivityFinderExtensions
local WM = WINDOW_MANAGER
local libScroll = LibScroll
local PledgeList = GAFE.DungeonPledgeList
local PledgeQuestName = GAFE.DungeonPledgeQuestName

GAFE_PledgesSchedule = ZO_Object:Subclass()

function GAFE_PledgesSchedule:New (...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function GAFE_PledgesSchedule:Initialize(control)
    self.control = control

    self.listContainer = self.control:GetNamedChild("ListContainer")

    self:InitializeControls()
end

function GAFE_PledgesSchedule:InitializeControls()
    self:InitializeFragment()
end

function GAFE_PledgesSchedule:InitializeFragment()
    local function GetPledgesOfDay(day)
        local dayPledges = {}
        for npc=1,3 do
            local dpList=PledgeList[npc]
            local n=1+(day+dpList.shift)%#dpList
            dayPledges[npc] = dpList[n]
        end
        return dayPledges
    end

    local function SetupDataRow(rowControl, data, scrollList)
        -- Do whatever you want/need to setup the control
        local control = rowControl
        local label = control:GetNamedChild("Label")
        local maj = control:GetNamedChild("Maj")
        local glirion = control:GetNamedChild("Glirion")
        local urgarlag = control:GetNamedChild("Urgarlag")

        label:SetText(zo_strformat(GAFE.Loc("InXDays"), data.day))
        maj:SetText(data.maj)
        glirion:SetText(data.glirion)
        urgarlag:SetText(data.urgarlag)

        local height = 30
        local labelWidth = 80
        local pledgeWidth = 165

        label:SetDimensions(labelWidth, height)
        label:SetAnchor(TOPLEFT, control, TOPLEFT, 0, 0)
        maj:SetDimensions(pledgeWidth, height)
        maj:SetAnchor(TOPLEFT, control, TOPLEFT, labelWidth, 0)
        glirion:SetDimensions(pledgeWidth, height)
        glirion:SetAnchor(TOPLEFT, control, TOPLEFT, labelWidth + pledgeWidth, 0)
        urgarlag:SetDimensions(pledgeWidth, height)
        urgarlag:SetAnchor(TOPLEFT, control, TOPLEFT, labelWidth + pledgeWidth * 2, 0)
    end

    local parent = self.listContainer

    -- Create the scroll list
    local scrollData = {
        name    = "GAFE_PledgesWindowScrollList",
        parent  = parent,
        rowHeight       = 30,
        rowTemplate     = "GAFE_PledgesScheduleRow",
        setupCallback   = SetupDataRow,
    }

    local scrollList = libScroll:CreateScrollList(scrollData)
    scrollList:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
    scrollList:SetAnchor(BOTTOMRIGHT, parent, BOTTOMRIGHT, 0, 0)

    -- Add data to scroll list.
    local today = math.floor(GetDiffBetweenTimeStamps(GetTimeStamp(), 1517464800) / 86400) -- 86400 = 1 day

    local dataItems = {}
    for day=1,20 do
        local pledges = GetPledgesOfDay(today + day)
        local data = {
            day=day,
            maj=PledgeQuestName[pledges[1]],
            glirion=PledgeQuestName[pledges[2]],
            urgarlag=PledgeQuestName[pledges[3]]
        }
        dataItems[day] = data
    end
    scrollList:Update(dataItems)

    self.scrollList = scrollList
end

function GAFE_PledgesSchedule_Init(control)
    GAFE.ActivitySchedule = GAFE_PledgesSchedule:New(control)
end
