local GAFE = GroupActivityFinderExtensions
local CS = CHAT_SYSTEM

GAFE.Chat = {}

function GAFE.Chat.SendMessage(message)
    StartChatInput(message)
    ZO_ChatWindowTextEntryEditBox:SelectAll()
end
