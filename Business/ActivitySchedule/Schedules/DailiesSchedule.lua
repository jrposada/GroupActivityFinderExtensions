local GAFE = GroupActivityFinderExtensions
local WM = WINDOW_MANAGER
local libScroll = LibScroll

GAFE_DailiesSchedule = ZO_Object:Subclass()

function GAFE_DailiesSchedule:New (...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function GAFE_DailiesSchedule:Initialize(control)
    self.control = control

    self:InitializeControls()
end

function GAFE_DailiesSchedule:InitializeControls()
    self:InitializeFragment()
end

function GAFE_DailiesSchedule:InitializeFragment()
    local function SetupDataRow(rowControl, data, scrollList)
        -- Do whatever you want/need to setup the control
        rowControl:SetText(data.name)
        rowControl:SetFont("ZoFontWinH4")
    end

    local parent = self.control

    -- Create the scroll list
    local scrollData = {
        name    = "GAFE_DailiesWindowScrollList",
        parent  = parent,
        -- width   = 300,
        -- height  = 500,

        -- rowHeight       = 23,
        -- rowTemplate     = "EmoteItRowControlTemplate",
        setupCallback   = SetupDataRow,
        -- sortFunction    = SortScrollList,
        -- selectTemplate  = "EmoteItSelectTemplate",
        -- selectCallback  = OnRowSelection,

        -- dataTypeSelectSound = SOUNDS.BOOK_CLOSE,
        -- hideCallback    = OnRowHide,
        -- resetCallback   = OnRowReset,

        -- categories  = {1, 2},
    }

    self.scrollList = libScroll:CreateScrollList(scrollData)
    self.scrollList:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
    self.scrollList:SetAnchor(BOTTOMRIGHT, parent, BOTTOMRIGHT, 50, 0)

    -- Add data to scroll list.
    local dataItems = {
    }
    for i=1,100 do
        local data = {name= i..'asdf asdf asdf asdfasdfasdfa sdfa sdfa sdfa  '}
    end
    self.scrollList:Update(dataItems)
end

function GAFE_DailiesSchedule_Init(control)
    GAFE.ActivitySchedule = GAFE_DailiesSchedule:New(control)
end