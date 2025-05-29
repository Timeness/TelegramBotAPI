module TelegramClientModule

using HTTP
using JSON3
using StructTypes
using ..TelegramTypes
using Sockets

export TelegramClient, start, stop, run, send, set_client!

mutable struct TelegramClient
    token::String
    chat_id::Union{String, Nothing}
    api_endpoint::String
    running::Bool
    dispatcher::Union{Dispatcher, Nothing}
end

TelegramClient(token::String; chat_id::Union{String, Nothing}=nothing, api_endpoint::String="https://api.telegram.org/bot") = TelegramClient(token, chat_id, api_endpoint, false, nothing)

mutable struct GlobalClient
    client::Union{TelegramClient, Nothing}
end

const GLOBAL_CLIENT = GlobalClient(nothing)

function set_client!(client::TelegramClient)
    GLOBAL_CLIENT.client = client
    return nothing
end

struct TelegramAPIError <: Exception
    code::Int
    message::String
end

async function send(method::String, params::Dict, files::Dict=Dict(); client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    if client === nothing
        error("No Telegram client configured.")
    end
    url = "$(client.api_endpoint)$(client.token)/$(method)"
    local response
    if isempty(files)
        headers = ["Content-Type" => "application/json"]
        body = JSON3.write(params)
        response = await HTTP.post(url, headers, body; retries=3, retry_delay=1)
    else
        form = HTTP.Form(Dict(params..., files...))
        response = await HTTP.post(url, [], form; retries=3, retry_delay=1)
    end
    if response.status != 200
        throw(TelegramAPIError(response.status, String(response.body)))
    end
    json = JSON3.read(response.body)
    if !json.ok
        throw(TelegramAPIError(json.error_code, json.description))
    end
    return json.result
end

async function start(client::TelegramClient)
    if client.running
        error("Client is already running.")
    end
    client.running = true
    user = await send("getMe", Dict(); client=client)
    @info "Started client for bot $(user.username)"
    return client
end

async function stop(client::TelegramClient)
    if !client.running
        error("Client is not running.")
    end
    client.running = false
    if client.dispatcher !== nothing
        await deleteWebhook(client=client)
    end
    @info "Stopped client"
    return nothing
end

async function run(client::TelegramClient)
    await start(client)
    try
        if client.dispatcher !== nothing
            await run_bot(client.dispatcher; client=client)
        else
            await idle()
        end
    finally
        await stop(client)
    end
end

async function idle()
    while true
        await sleep(1)
    end
end

end
