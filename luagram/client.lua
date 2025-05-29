local json = require("luagram.utils.json")
local td_send = require("luagram.utils.td_send")

local Client = {}
Client.__index = Client

function Client:new(api_hash, bot_token)
    local self = setmetatable({}, Client)
    self.api_hash = api_hash
    self.bot_token = bot_token
    self.update_handlers = {}
    return self
end

function Client:start()
    td_send.init_tdlib()
    td_send.send({
        ["@type"] = "checkAuthenticationBotToken",
        token = self.bot_token
    })

    while true do
        local update = td_send.receive()
        if update then
            for _, handler in ipairs(self.update_handlers) do
                handler(update)
            end
        end
    end
end

function Client:on_update(handler)
    table.insert(self.update_handlers, handler)
end

function Client:send_message(chat_id, text)
    td_send.send({
        ["@type"] = "sendMessage",
        chat_id = chat_id,
        input_message_content = {
            ["@type"] = "inputMessageText",
            text = {
                ["@type"] = "formattedText",
                text = text
            }
        }
    })
end

return Client