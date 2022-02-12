local GAFE = GroupActivityFinderExtensions
local WM = WINDOW_MANAGER
local libScroll = LibScroll
-- local TrialQuest = GAFE.TrialChestTimer.TrialQuest

GAFE_TrialsSchedule = ZO_Object:Subclass()

function GAFE_TrialsSchedule:New (...)
    local instance = ZO_Object.New(self)
    instance:Initialize(...)
    return instance
end

function GAFE_TrialsSchedule:Initialize(control)
    self.control = control

    self.container = self.control:GetNamedChild("Container")

    self:InitializeControls()
end

function GAFE_TrialsSchedule:InitializeControls()
    self:InitializeFragment()
end

function GAFE_TrialsSchedule:InitializeFragment()
    local function SetupDataRow(rowControl, data, scrollList)
        -- Do whatever you want/need to setup the control
        rowControl:SetText(data.name)
        rowControl:SetFont("ZoFontWinH4")
    end

    local scrollChild = self.container:GetNamedChild("ScrollChild")

    -- Create the scroll list
    local scrollData = {
        name    = "MyTestScrollList",
        parent  = scrollChild,
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

    -- self.scrollList = libScroll:CreateScrollList(scrollData)
    -- self.scrollList:SetAnchor(TOPLEFT, scrollChild, TOPLEFT, 0, 0)
    -- self.scrollList:SetAnchor(BOTTOMRIGHT, scrollChild, BOTTOMRIGHT, 50, 0)


    -- Add data to scroll list.
    -- local dataItems = {
    -- }
    -- for i=1,100 do
    --     local data = {name= i..'asdf asdf asdf asdfasdfasdfa sdfa sdfa sdfa  '}

        
    -- end
    -- GAFE.UI.ZOButton("GAFE_PledgesCheck", scrollChild, {200, 200}, {TOP,scrollChild,TOP,0,0}, GAFE.Loc("CheckActivePledges"))

    -- self.scrollList:Update(dataItems)

    --     h5. ScrollBounding
    -- * SCROLL_BOUNDING_BOUND
    -- * SCROLL_BOUNDING_CONTAINED
    -- * SCROLL_BOUNDING_DEFAULT
    -- * SCROLL_BOUNDING_UNBOUND
    -- self.scroll:SetScrollBounding(SCROLL_BOUNDING_UNBOUND)
    -- local scrollWidth = self.scroll:GetWidth()
    -- local currentHorizonalScrollOffset, currentVerticalScrollOffset = self.scroll:GetScrollOffsets()
    -- GAFE.LogLater("width | "..scrollWidth)
    -- -- Scroll the selected lore entry to the center of the scroll control's view.
    -- local controlOffset = self.scrollList:GetTop()
    -- local controlWidth = self.scrollList:GetWidth()
    -- local targetOffset = currentHorizonalScrollOffset + controlOffset - 0.5 * (scrollWidth - controlWidth)
    -- self.scroll:SetHorizontalScroll(20)
end

function GAFE_TrialsSchedule_Init(control)
    GAFE.ActivitySchedule = GAFE_TrialsSchedule:New(control)
end