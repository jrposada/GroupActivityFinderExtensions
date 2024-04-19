ChatMessage = ZO_Object:Subclass()

function ChatMessage:New(...)
    local instance = ZO_Object:New(self)
    instance:Initialize(...)
    return instance
end

function ChatMessage:Initialize(prefix)
    self.prefix = prefix
    self.maxCharacters = 1500
    self.buffer = {
        [1] = '',
    }
end

function ChatMessage:AddMessage(message)
    if message == nil then return end

    local currentBufferIndex = #self.buffer
    local currentBufferLength = string.len(self.buffer[currentBufferIndex])
    local messageLength = string.len(message)
    if (messageLength <= self.maxCharacters - currentBufferLength) then
        self.buffer[currentBufferIndex] = self.buffer[currentBufferIndex] .. message
    elseif (messageLength <= self.maxCharacters) then
        self.buffer[currentBufferIndex + 1] = message
    else
        self.buffer[currentBufferIndex + 1] = 'Message was to long to submit'
        self.buffer[currentBufferIndex + 2] = ''
    end
end

function ChatMessage:Submit()
    for _, message in ipairs(self.buffer) do
        CHAT_SYSTEM:AddMessage(self.prefix .. message)
    end

    self.buffer = {
        [1] = ''
    }
end
