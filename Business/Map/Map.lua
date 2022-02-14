local GAFE = GroupActivityFinderExtensions

GAFE.Map = {}

local myButtonGroup

function GAFE.Map.Init()
    -- GAFE.Debug.LogControlShown()
    -- GAFE.Debug.LogNodeIds()
    local function OnShown()
        -- TODO: add to settings
        local nodeIndex = 382
        local knownNode, name = GetFastTravelNodeInfo(nodeIndex)

        local function TeleportToHome()
            -- TODO: figure out how to know if there is going to be a cost.
            local cost = GetRecallCost(nodeIndex)
            if knownNode then
                if cost == 0 then
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