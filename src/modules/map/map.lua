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
                    ZO_Dialogs_ShowPlatformDialog("FAST_TRAVEL_CONFIRM", { nodeIndex = nodeIndex },
                        { mainTextParams = { name } })
                else
                    ZO_Dialogs_ShowPlatformDialog("RECALL_CONFIRM", { nodeIndex = nodeIndex }, { mainTextParams = { name } })
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
        local function FastTravelToAllianceCity(params)
            local nodeIndex, parent, position, texture = params.nodeIndex, params.parent, params.position, params
            .texture
            local size = 30

            local knownNode, name = GetFastTravelNodeInfo(nodeIndex)
            local xOffset = 4
            GAFE.UI.Texture(parent:GetName() .. "GAFE_Label" .. nodeIndex, parent, { size, size * 2 },
                { TOPLEFT, parent, TOPLEFT, position * size + xOffset, -45 }, texture)
            local button = GAFE.UI.Button(parent:GetName() .. "GAFE_Button" .. nodeIndex, parent, { size * 1.2, size *
            1.2 }, { TOPLEFT, parent, TOPLEFT, position * size + xOffset + size - 10, -47 }, nil,
                function() TeleportTo(nodeIndex) end, true, name)
            if knownNode then
                button:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_complete.dds")
                button:SetMouseOverTexture("/esoui/art/icons/poi/poi_wayshrine_glow.dds")
            else
                button:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_incomplete.dds")
            end
        end

        local parent = ZO_WorldMapInfo
        FastTravelToAllianceCity({ nodeIndex = 214, parent = parent, position = 0, texture =
        "/esoui/art/ava/ava_allianceflag_aldmeri.dds" })
        FastTravelToAllianceCity({ nodeIndex = 56, parent = parent, position = 2, texture =
        "/esoui/art/ava/ava_allianceflag_daggerfall.dds" })
        FastTravelToAllianceCity({ nodeIndex = 28, parent = parent, position = 4, texture =
        "/esoui/art/ava/ava_allianceflag_ebonheart.dds" })
        -- FastTravelToAllianceCity({nodeIndex=220, parent=parent, position=6, texture=}) -- Craglorn
    end

    local function OnHidden()
        KEYBIND_STRIP:RemoveKeybindButtonGroup(keybindStripGroup)
    end

    ZO_PreHookHandler(ZO_WorldMapInfo, 'OnEffectivelyShown', OnShown)
    ZO_PreHookHandler(ZO_WorldMapInfo, 'OnEffectivelyHidden', OnHidden)

    EVENT_MANAGER:RegisterForEvent(GAFE.name .. "_Map", EVENT_START_FAST_TRAVEL_INTERACTION, OnFastTravelStart)
    EVENT_MANAGER:RegisterForEvent(GAFE.name .. "_Map", EVENT_END_FAST_TRAVEL_INTERACTION, OnFastTravelEnd)
end
