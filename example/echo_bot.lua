local Client = require("luagram.client")

local app = Client:new("your_api_hash_here", "your_bot_token_here")

app:on_update(function(update)
    if update["@type"] == "updateNewMessage" then
        local msg = update.message
        if msg and msg.content and msg.content.text then
            local text = msg.content.text.text
            app:send_message(msg.chat_id, "Echo: " .. text)
        end
    end
end)

app:start()
