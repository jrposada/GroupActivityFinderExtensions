local GAFE = GroupActivityFinderExtensions

GAFE.Map = {}

local myButtonGroup

function GAFE.Map.Init()
    local function OnShown()
        -- TODO: add to settings
        local nodeIndex = 284
        local knownNode, name = GetFastTravelNodeInfo(nodeIndex)

        local function TeleportToHome()
            -- FIXME: figure out how to know if there is going to be a cost.
            local cooldown = GetRecallCooldown()
            local cost = GetRecallCost(nodeIndex)

            if knownNode then
                if cost == 0 and cooldown ~= nil then
                    ZO_Dialogs_ShowPlatformDialog("FAST_TRAVEL_CONFIRM", {nodeIndex = nodeIndex}, {mainTextParams = {name}})
                else
                    ZO_Dialogs_ShowPlatformDialog("RECALL_CONFIRM", {nodeIndex = nodeIndex}, {mainTextParams = {name}})
                end
            end
        end

        myButtonGroup = {
            {
                name = name,
                keybind = "UI_SHORTCUT_QUATERNARY",
                callback = function() TeleportToHome() end,
            },
            alignment = KEYBIND_STRIP_ALIGN_CENTER,
        }
        KEYBIND_STRIP:AddKeybindButtonGroup(myButtonGroup)
    end

    local function OnHidden()
        KEYBIND_STRIP:RemoveKeybindButtonGroup(myButtonGroup)
    end

    ZO_PreHookHandler(ZO_WorldMapInfo, 'OnEffectivelyShown', OnShown)
	ZO_PreHookHandler(ZO_WorldMapInfo, 'OnEffectivelyHidden', OnHidden)
end


-- TODO: Add to map
-- local function FastTravelToAllianceCity(nodeIndex, allianceId, parent)
-- 	if nodeIndex then
--         local knownNode, name = GetFastTravelNodeInfo(nodeIndex)
--         local size = 30
-- 		local texture, position
-- 		if allianceId == AllianceId.Aldmeri then
-- 			texture = "/esoui/art/ava/ava_allianceflag_aldmeri.dds"
-- 			position = 0
-- 		elseif allianceId == AllianceId.Daggerfall then
-- 			texture = "/esoui/art/ava/ava_allianceflag_daggerfall.dds"
-- 			position = size * 2
-- 		elseif allianceId == AllianceId.Ebonheart then
-- 			texture = "/esoui/art/ava/ava_allianceflag_ebonheart.dds"
-- 			position = size * 4
-- 		end

-- 		GAFE.UI.Texture(parent:GetName().."Label"..allianceId, parent, {size,size*2}, {TOPLEFT,parent,TOPLEFT,position, -40}, texture)
--         local button = GAFE.UI.Button(parent:GetName().."Button"..allianceId, parent, {size*1.2,size*1.2}, {TOPLEFT,parent,TOPLEFT,position+size-10, -40}, nil, function() finderActivityExtender:FastTravel(nodeIndex, name) end, knownNode)
--         if knownNode then
--             button:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_complete.dds")
--         else
--             button:SetNormalTexture("/esoui/art/icons/poi/poi_wayshrine_incomplete.dds")
--         end
--     end
-- end


-- FastTravelToAllianceCity(214, AllianceId.Aldmeri, parent)
-- FastTravelToAllianceCity(56, AllianceId.Daggerfall, parent)
-- FastTravelToAllianceCity(28, AllianceId.Ebonheart, parent)
