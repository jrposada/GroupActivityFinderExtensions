local GAFE = GroupActivityFinderExtensions
local WM = WINDOW_MANAGER
local libScroll = LibScroll
local PledgeList = GAFE.DungeonPledgeList
local PledgeQuestName = GAFE.DungeonPledgeQuestName

local function GetPledgesOfDay(day)
    local dayPledges = {}
    for npc=1,3 do
        local dpList=PledgeList[npc]
        local n=1+(day+dpList.shift)%#dpList
        dayPledges[npc] = dpList[n]
    end
    return dayPledges
end

GAFE_PledgesSchedule = ZO_Object:Subclass()


function GAFE_PledgesSchedule:New (...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function GAFE_PledgesSchedule:Initialize(control)
    self.control = control

    self.filter = self.control:GetNamedChild("Filter")

    self.today = self.control:GetNamedChild("Today")
    self.todayHeader = self.today:GetNamedChild("Header")
    self.todayListContainer = self.today:GetNamedChild("ListContainer")
    
    self.upcoming = self.control:GetNamedChild("Upcoming")
    self.upcomingHeader = self.upcoming:GetNamedChild("Header")
    self.upcomingListContainer = self.upcoming:GetNamedChild("ListContainer")

    self:InitializeControls()
end

function GAFE_PledgesSchedule:InitializeControls()
    self:InitializeFilter()
    self:InitializeTodayFragment()
    self:InitializeUpcomingFragment()
end

function GAFE_PledgesSchedule:InitializeFilter()
    local function OnFilterChanged(...)
        self:OnFilterChanged(...)
    end

    local filterComboBox = ZO_ComboBox_ObjectFromContainer(self.filter)
    filterComboBox:SetSortsItems(false)
    filterComboBox:SetFont("ZoFontWinT1")
    filterComboBox:SetSpacing(4)
    self.filterComboBox = filterComboBox

    local todayEntry = ZO_ComboBox:CreateItemEntry("Today", OnFilterChanged)
    todayEntry.data = 'today'
    self.filterComboBox:AddItem(todayEntry, ZO_COMBOBOX_SUPPRESS_UPDATE)
    local upcomingEntry = ZO_ComboBox:CreateItemEntry("Upcoming", OnFilterChanged)
    upcomingEntry.data = 'upcoming'
    self.filterComboBox:AddItem(upcomingEntry, ZO_COMBOBOX_SUPPRESS_UPDATE)

    self.filterComboBox:SelectItem(todayEntry)
end

function GAFE_PledgesSchedule:InitializeTodayFragment()
    local function SetupHeaderRow(rowControl, data)
        -- Do whatever you want/need to setup the control
        local control = rowControl
        local label = control:GetNamedChild("Label")
        local maj = control:GetNamedChild("Maj")
        local glirion = control:GetNamedChild("Glirion")
        local urgarlag = control:GetNamedChild("Urgarlag")

        label:SetText(data.character)
        maj:SetText(data.maj)
        glirion:SetText(data.glirion)
        urgarlag:SetText(data.urgarlag)

        label:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
        maj:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
        glirion:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
        urgarlag:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))

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

    local function SetupDataRow(rowControl, data, scrollList)
        -- Do whatever you want/need to setup the control
        local control = rowControl
        local label = control:GetNamedChild("Label")
        local maj = control:GetNamedChild("Maj")
        local glirion = control:GetNamedChild("Glirion")
        local urgarlag = control:GetNamedChild("Urgarlag")

        label:SetText(data.character)
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

    local today = math.floor(GetDiffBetweenTimeStamps(GetTimeStamp(), 1517464800) / 86400) -- 86400 = 1 day
    local pledges = GetPledgesOfDay(today)

    -- Setup header
    SetupHeaderRow(
        self.todayHeader,
        {
            name='',
            maj=PledgeQuestName[pledges[1]],
            glirion=PledgeQuestName[pledges[2]],
            urgarlag=PledgeQuestName[pledges[3]],
        }
    )

    local parent = self.todayListContainer

    -- Create the scroll list
    local scrollData = {
        name    = "GAFE_PledgesWindowTodayScrollList",
        parent  = parent,
        rowHeight       = 30,
        rowTemplate     = "GAFE_PledgesScheduleRow",
        setupCallback   = SetupDataRow,
    }

    local scrollList = libScroll:CreateScrollList(scrollData)
    scrollList:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
    scrollList:SetAnchor(BOTTOMRIGHT, parent, BOTTOMRIGHT, 0, 0)

    -- Add data to scroll list.
    local dataItems = {}
    local numCharacters = GetNumCharacters()
    for i = 1, numCharacters do
        local characterName, _, _, _, _, _, characterId, _ = GetCharacterInfo(i)

        local donePledges = GAFE.SavedVars.dungeons.donePledges[characterId] or {};
        local data = {
            character=zo_strformat("<<1>>", characterName),
            maj=GAFE.ContainsKey(donePledges, pledges[1]) and 'Done' or "|cFFD700Available|r",
            glirion=GAFE.ContainsKey(donePledges, pledges[2]) and 'Done' or "|cFFD700Available|r",
            urgarlag=GAFE.ContainsKey(donePledges, pledges[3]) and 'Done' or "|cFFD700Available|r"
        }
        dataItems[i] = data
    end
    scrollList:Update(dataItems)

    self.todayScrollList = scrollList
end

function GAFE_PledgesSchedule:InitializeUpcomingFragment()
    local function SetupHeaderRow(rowControl, data, scrollList)
        -- Do whatever you want/need to setup the control
        local control = rowControl
        local label = control:GetNamedChild("Label")
        local maj = control:GetNamedChild("Maj")
        local glirion = control:GetNamedChild("Glirion")
        local urgarlag = control:GetNamedChild("Urgarlag")

        label:SetText(data.character)
        maj:SetText(data.maj)
        glirion:SetText(data.glirion)
        urgarlag:SetText(data.urgarlag)

        label:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
        maj:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
        glirion:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
        urgarlag:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))

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

    -- Setup header
    SetupHeaderRow(
        self.upcomingHeader,
        {
            character='',
            maj="Maj",
            glirion="Glirion",
            urgarlag="Urgarlag",
        }
    )

    local parent = self.upcomingListContainer

    -- Create the scroll list
    local scrollData = {
        name    = "GAFE_PledgesWindowUpcomingScrollList",
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
    for day=1,14 do
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

    self.upcomingScrollList = scrollList
end

function GAFE_PledgesSchedule:OnFilterChanged(comboBox, entryText, entry)
    self.today:SetHidden(entry.data ~= 'today')
    self.upcoming:SetHidden(entry.data ~= 'upcoming')
end

function GAFE_PledgesSchedule_Init(control)
    GAFE.ActivitySchedule = GAFE_PledgesSchedule:New(control)
end
