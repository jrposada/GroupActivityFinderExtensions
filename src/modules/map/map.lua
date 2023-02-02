local GAFE = GroupActivityFinderExtensions

GAFE_MAP = {}

function GAFE_MAP.Init()
    local keybindStripGroup
    local isFastTravel = false

    local function OnFastTravelStart()
        isFastTravel = true
    end

    local function OnFastTravelEnd()
        isFastTravel = false
    end

    local function OnShown()
        local favouriteNode = GAFE.SavedVars.map.favourite
        local _, favouriteNodeName = GetFastTravelNodeInfo(favouriteNode)

        local function TeleportTo(nodeIndex)
            local knownNode, name = GetFastTravelNodeInfo(nodeIndex)

            if knownNode then
                if isFastTravel then
                    ZO_Dialogs_ShowPlatformDialog("FAST_TRAVEL_CONFIRM", {nodeIndex = nodeIndex}, {mainTextParams = {name}})
                else
                    ZO_Dialogs_ShowPlatformDialog("RECALL_CONFIRM", {nodeIndex = nodeIndex}, {mainTextParams = {name}})
                end
            end
        end

        keybindStripGroup = {
            {
                name = favouriteNodeName,
                keybind = "UI_SHORTCUT_QUATERNARY",
                callback = function() TeleportTo(favouriteNode) end,
            },
            alignment = KEYBIND_STRIP_ALIGN_CENTER,
        }
        KEYBIND_STRIP:AddKeybindButtonGroup(keybindStripGroup)

        -- Add Fast travel to alliances
        local function FastTravelToAllianceCity(nodeIndex, allianceId, parent)
            local size = 30
            local texture, position
            if allianceId == GAFE_ALLIANCE_ID.Aldmeri then
                texture = "/esoui/art/ava/ava_allianceflag_aldmeri.dds"
                position = 0
            elseif allianceId == GAFE_ALLIANCE_ID.Daggerfall then
                texture = "/esoui/art/ava/ava_allianceflag_daggerfall.dds"
                position = size * 2
            elseif allianceId == GAFE_ALLIANCE_ID.Ebonheart then
                texture = "/esoui/art/ava/ava_allianceflag_ebonheart.dds"
                position = size * 4
            end
    
            local knownNode, name = GetFastTravelNodeInfo(nodeIndex)
            local xOffset = 4
            GAFE.UI.Texture(parent:GetName().."GAFE_Label"..allianceId, parent, {size,size*2}, {TOPLEFT,parent,TOPLEFT,position + xOffset, -45}, texture)
            local button = GAFE.UI.Button(parent:GetName().."GAFE_Button"..allianceId, parent, {size*1.2,size*1.2}, {TOPLEFT,parent,TOPLEFT,position + xOffset + size - 10, -47}, nil, function() TeleportTo(nodeIndex) end, true, name)
            if knownNode then
                button:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_complete.dds")
                button:SetMouseOverTexture("/esoui/art/icons/poi/poi_wayshrine_glow.dds")
            else
                button:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_incomplete.dds")
            end
        end

        local parent = ZO_WorldMapInfo
        FastTravelToAllianceCity(214, GAFE_ALLIANCE_ID.Aldmeri, parent)
        FastTravelToAllianceCity(56, GAFE_ALLIANCE_ID.Daggerfall, parent)
        FastTravelToAllianceCity(28, GAFE_ALLIANCE_ID.Ebonheart, parent)
    end

    local function OnHidden()
        KEYBIND_STRIP:RemoveKeybindButtonGroup(keybindStripGroup)
    end

    ZO_PreHookHandler(ZO_WorldMapInfo, 'OnEffectivelyShown', OnShown)
	ZO_PreHookHandler(ZO_WorldMapInfo, 'OnEffectivelyHidden', OnHidden)

    EVENT_MANAGER:RegisterForEvent(GAFE.name .. "_Map", EVENT_START_FAST_TRAVEL_INTERACTION, OnFastTravelStart)
    EVENT_MANAGER:RegisterForEvent(GAFE.name .. "_Map", EVENT_END_FAST_TRAVEL_INTERACTION, OnFastTravelEnd)
end
