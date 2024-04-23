local GAFE = GroupActivityFinderExtensions

local eventName = GAFE.name .. "autoBind"

local function IsUncollectedItem(bagId, slotIndex, link)
    local result = false
    local _, stackCount, sellPrice, _, _, equipType, itemStyle, quality = GetItemInfo(bagId, slotIndex)

    if stackCount < 1 then return false end

    local itemId = GetItemLinkItemId(link)
    local itemType, specializedItemType = GetItemLinkItemType(link)

    if (itemType == ITEMTYPE_ARMOR or itemType == ITEMTYPE_WEAPON) then
        local isSetCollectionPiece = IsItemLinkSetCollectionPiece(link)
        local isUnlocked = IsItemSetCollectionPieceUnlocked(itemId)
        local isBound = IsItemLinkBound(link)

        if not isBound and isSetCollectionPiece and not isUnlocked then
            result = true
        end
    end

    return result
end

local function OnInventoryChanged(_, bagId, slotIndex, _isNewItem_, _itemSoundCategory_, _inventoryUpdateReason_,
                                  _stackCountChange_, _triggeredByCharacterName_, _triggeredByDisplayName_,
                                  _isLastUpdateForMessage_, _bonusDropSource_)
    local link = GetItemLink(bagId, slotIndex)

    if IsUncollectedItem(bagId, slotIndex, link) then
        BindItem(bagId, slotIndex)

        local texture = GetItemLinkIcon(link)
        ChatMessage:New("[GAFE:Bind] " .. zo_strformat(" |t18:18:<<2>>|t <<t:1>>", link, texture)):Submit()
    end
end

local function RegisterEvents()
    EVENT_MANAGER:RegisterForEvent(eventName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, OnInventoryChanged)
end

local function UnregisterEvents()
    EVENT_MANAGER:UnregisterForEvent(eventName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
end

local function Init()
    local savedVars = GAFE.SavedVars

    if savedVars.autoBind.enabled then
        RegisterEvents()
    else
        UnregisterEvents()
    end
end


GAFE_AUTO_BIND = {}

function GAFE_AUTO_BIND.Init()
    Init()
end

function GAFE_AUTO_BIND.Enable(enable)
    local savedVars = GAFE.SavedVars

    savedVars.autoBind.enabled = enable

    Init()
end
