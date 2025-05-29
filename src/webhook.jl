module TelegramWebhook

using HTTP
using JSON3
using ..TelegramTypes
using ..TelegramHandlers
using ..TelegramClientModule

export run_webhook

async function run_webhook(dispatcher::Dispatcher; webhook_url::String, port::Int=8080)
    await send("setWebhook", Dict("url" => webhook_url); client=dispatcher.client)
    server = HTTP.serve() do request
        try
            update = JSON3.read(request.body, Update)
            @async process_update(dispatcher, update)
            return HTTP.Response(200)
        catch e
            @error "Webhook error: $e"
            return HTTP.Response(500)
        end
    end
    await HTTP.serve(server, "0.0.0.0", port)
end

end
