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