module TelegramBotAPI

using HTTP
using JSON3
using StructTypes
using Logging
using LoggingExtras
using Sockets

include("types.jl")
include("client.jl")
include("methods.jl")
include("filters.jl")
include("handlers.jl")
include("middleware.jl")
include("webhook.jl")
include("iterators.jl")
include("utils.jl")

using .TelegramTypes
using .TelegramClientModule
using .TelegramMethods
using .TelegramFilters
using .TelegramHandlers
using .TelegramMiddleware
using .TelegramWebhook
using .TelegramIterators
using .TelegramUtils

export TelegramClient, start, stop, run, send, set_client!, getMe, send_message, edit_message_text, delete_messages, forward_messages, copy_message, send_photo, send_video, send_document, send_audio, send_animation, send_sticker, send_media_group, send_poll, send_dice, get_messages, pin_chat_message, unpin_chat_message, download_media, upload_file, get_users, get_profile_photos, get_chat, get_chat_members, get_chat_member, promote_chat_member, restrict_chat_member, kick_chat_member, ban_chat_member, unban_chat_member, approve_chat_join_request, decline_chat_join_request, Dispatcher, MessageHandler, CallbackQueryHandler, InlineQueryHandler, ChatJoinRequestHandler, PreCheckoutQueryHandler, SuccessfulPaymentHandler, add_handler!, on_message, on_callback_query, on_inline_query, on_chat_join_request, on_pre_checkout_query, on_successful_payment, Filter, command, text, media, document, photo, audio, video, reply, sticker, private, group, channel, bot, regex, Middleware, apply_middleware, run_webhook, iter_chat_members, iter_chat_messages, iter_dialogs, iter_history, get_chat_history, get_dialogs, set_parse_mode, get_parse_mode, get_inline_bot_results, send_inline_bot_result, send_invoice, send_voice, send_video_note, send_contact, send_location, send_venue, send_game, send_chat_action, create_inline_keyboard, create_reply_keyboard

struct TelegramLogger <: AbstractLogger
    client::TelegramClient
    min_level::LogLevel
    async::Bool
end

function TelegramLogger(client::TelegramClient; min_level::LogLevel=Logging.Info, async::Bool=true)
    TelegramLogger(client, min_level, async)
end

Logging.shouldlog(logger::TelegramLogger, level, _module, group, id) = level >= logger.min_level
Logging.min_enabled_level(logger::TelegramLogger) = logger.min_level
Logging.catch_exceptions(logger::TelegramLogger) = true

async function Logging.handle_message(logger::TelegramLogger, level, message, _module, group, id, file, line; kwargs...)
    if logger.async
        @async send_message(string(level, ": ", message); client=logger.client)
    else
        await send_message(string(level, ": ", message); client=logger.client)
    end
end

async function run_bot(dispatcher::Dispatcher; use_webhook::Bool=false, webhook_url::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    if use_webhook
        if webhook_url === nothing
            error("Webhook URL must be provided when use_webhook is true")
        end
        await run_webhook(dispatcher; webhook_url=webhook_url)
    else
        offset = 0
        while client.running
            try
                updates = await send("getUpdates", Dict("offset" => offset, "timeout" => 60); client=client)
                for update in updates
                    offset = max(offset, update.update_id + 1)
                    @async process_update(dispatcher, JSON3.read(JSON3.write(update), Update))
                end
            catch e
                @error "Error in bot loop: $e"
                await sleep(1)
            end
        end
    end
end

end
