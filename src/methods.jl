module TelegramMethods

using HTTP
using JSON3
using StructTypes
using ..TelegramTypes
using ..TelegramClientModule

export getMe, send_message, edit_message_text, delete_messages, forward_messages, copy_message, send_photo, send_video, send_document, send_audio, send_animation, send_sticker, send_media_group, send_poll, send_dice, get_messages, pin_chat_message, unpin_chat_message, download_media, upload_file, get_users, get_profile_photos, get_chat, get_chat_members, get_chat_member, promote_chat_member, restrict_chat_member, kick_chat_member, ban_chat_member, unban_chat_member, approve_chat_join_request, decline_chat_join_request, answer_callback_query, answer_inline_query, get_chat_history, get_dialogs, set_parse_mode, get_parse_mode, get_inline_bot_results, send_inline_bot_result, send_invoice, send_animation, send_voice, send_video_note, send_contact, send_location, send_venue, send_game, send_chat_action

async function getMe(; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    result = await send("getMe", Dict(); client=client)
    return JSON3.read(JSON3.write(result), User)
end

async function send_message(text::String; chat_id::Union{String, Nothing}=nothing, reply_markup::Union{InlineKeyboardMarkup, ReplyKeyboardMarkup, ReplyKeyboardRemove, ForceReply, Nothing}=nothing, parse_mode::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    chat_id = something(chat_id, client.chat_id)
    params = Dict("chat_id" => chat_id, "text" => text)
    if reply_markup !== nothing
        params["reply_markup"] = JSON3.write(reply_markup)
    end
    if parse_mode !== nothing
        params["parse_mode"] = parse_mode
    end
    result = await send("sendMessage", params; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function edit_message_text(text::String; chat_id::String, message_id::Int, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "message_id" => message_id, "text" => text)
    result = await send("editMessageText", params; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function delete_messages(chat_id::String, message_ids::Union{Int, Vector{Int}}; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "message_ids" => message_ids isa Int ? [message_ids] : message_ids)
    await send("deleteMessages", params; client=client)
end

async function forward_messages(chat_id::String, from_chat_id::String, message_ids::Union{Int, Vector{Int}}; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "from_chat_id" => from_chat_id, "message_ids" => message_ids isa Int ? [message_ids] : message_ids)
    result = await send("forwardMessages", params; client=client)
    return [JSON3.read(JSON3.write(msg), Message) for msg in result]
end

async function copy_message(chat_id::String, from_chat_id::String, message_id::Int; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "from_chat_id" => from_chat_id, "message_id" => message_id)
    result = await send("copyMessage", params; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_photo(photo_path::String; chat_id::Union{String, Nothing}=nothing, caption::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    chat_id = something(chat_id, client.chat_id)
    params = Dict("chat_id" => chat_id)
    if caption !== nothing
        params["caption"] = caption
    end
    files = Dict("photo" => open(photo_path, "r"))
    result = await send("sendPhoto", params, files; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_video(video_path::String; chat_id::Union{String, Nothing}=nothing, caption::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    chat_id = something(chat_id, client.chat_id)
    params = Dict("chat_id" => chat_id)
    if caption !== nothing
        params["caption"] = caption
    end
    files = Dict("video" => open(video_path, "r"))
    result = await send("sendVideo", params, files; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_document(document_path::String; chat_id::Union{String, Nothing}=nothing, caption::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    chat_id = something(chat_id, client.chat_id)
    params = Dict("chat_id" => chat_id)
    if caption !== nothing
        params["caption"] = caption
    end
    files = Dict("document" => open(document_path, "r"))
    result = await send("sendDocument", params, files; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_audio(audio_path::String; chat_id::Union{String, Nothing}=nothing, caption::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    chat_id = something(chat_id, client.chat_id)
    params = Dict("chat_id" => chat_id)
    if caption !== nothing
        params["caption"] = caption
    end
    files = Dict("audio" => open(audio_path, "r"))
    result = await send("sendAudio", params, files; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_animation(animation_path::String; chat_id::Union{String, Nothing}=nothing, caption::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    chat_id = something(chat_id, client.chat_id)
    params = Dict("chat_id" => chat_id)
    if caption !== nothing
        params["caption"] = caption
    end
    files = Dict("animation" => open(animation_path, "r"))
    result = await send("sendAnimation", params, files; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_sticker(sticker_path::String; chat_id::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    chat_id = something(chat_id, client.chat_id)
    params = Dict("chat_id" => chat_id)
    files = Dict("sticker" => open(sticker_path, "r"))
    result = await send("sendSticker", params, files; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_media_group(media::Vector{Dict}; chat_id::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    chat_id = something(chat_id, client.chat_id)
    params = Dict("chat_id" => chat_id, "media" => JSON3.write(media))
    files = Dict{String, Any}()
    for (i, m) in enumerate(media)
        if haskey(m, "media") && isfile(m["media"])
            files["media$i"] = open(m["media"], "r")
            m["media"] = "attach://media$i"
        end
    end
    result = await send("sendMediaGroup", params, files; client=client)
    return [JSON3.read(JSON3.write(msg), Message) for msg in result]
end

async function send_poll(chat_id::String, question::String, options::Vector{String}; is_anonymous::Bool=true, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "question" => question, "options" => JSON3.write(options), "is_anonymous" => is_anonymous)
    result = await send("sendPoll", params; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_dice(chat_id::Union{String, Nothing}=nothing; emoji::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    chat_id = something(chat_id, client.chat_id)
    params = Dict("chat_id" => chat_id)
    if emoji !== nothing
        params["emoji"] = emoji
    end
    result = await send("sendDice", params; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function get_messages(chat_id::String, message_ids::Union{Int, Vector{Int}}; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "message_ids" => message_ids isa Int ? [message_ids] : message_ids)
    result = await send("getMessages", params; client=client)
    return [JSON3.read(JSON3.write(msg), Message) for msg in result]
end

async function pin_chat_message(chat_id::String, message_id::Int; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "message_id" => message_id)
    await send("pinChatMessage", params; client=client)
end

async function unpin_chat_message(chat_id::String, message_id::Int; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "message_id" => message_id)
    await send("unpinChatMessage", params; client=client)
end

async function download_media(message::Message, path::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    file_id = nothing
    if message.photo !== nothing
        file_id = message.photo[end].file_id
    elseif message.document !== nothing
        file_id = message.document.file_id
    elseif message.video !== nothing
        file_id = message.video.file_id
    elseif message.audio !== nothing
        file_id = message.audio.file_id
    elseif message.animation !== nothing
        file_id = message.animation.file_id
    elseif message.sticker !== nothing
        file_id = message.sticker.file_id
    end
    if file_id === nothing
        error("No media found in message")
    end
    file = await send("getFile", Dict("file_id" => file_id); client=client)
    file_path = file.file_path
    url = "$(client.api_endpoint[1:end-4])/file/bot$(client.token)/$file_path"
    response = await HTTP.get(url)
    write(path, response.body)
    return path
end

async function upload_file(file_path::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict()
    files = Dict("file" => open(file_path, "r"))
    result = await send("uploadFile", params, files; client=client)
    return result.file_id
end

async function get_users(user_ids::Union{Int, Vector{Int}}; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("user_ids" => user_ids isa Int ? [user_ids] : user_ids)
    result = await send("getUsers", params; client=client)
    return [JSON3.read(JSON3.write(user), User) for user in result]
end

async function get_profile_photos(user_id::Int; client::Union{TelegramClient, Nothing}= Ang = nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("user_id" => user_id)
    result = await send("getUserProfilePhotos", params; client=client)
    return [JSON3.read(JSON3.write(photo), PhotoSize) for photo in result.photos]
end

async function get_chat(chat_id::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id)
    result = await send("getChat", params; client=client)
    return JSON3.read(JSON3.write(result), Chat)
end

async function get_chat_members(chat_id::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id)
    result = await send("getChatMembers", params; client=client)
    return [JSON3.read(JSON3.write(member), ChatMember) for member in result]
end

async function get_chat_member(chat_id::String, user_id::Int; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "user_id" => user_id)
    result = await send("getChatMember", params; client=client)
    return JSON3.read(JSON3.write(result), ChatMember)
end

async function promote_chat_member(chat_id::String, user_id::Int; can_post_messages::Bool=false, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "user_id" => user_id, "can_post_messages" => can_post_messages)
    await send("promoteChatMember", params; client=client)
end

async function restrict_chat_member(chat_id::String, user_id::Int; permissions::Dict, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "user_id" => user_id, "permissions" => JSON3.write(permissions))
    await send("restrictChatMember", params; client=client)
end

async function kick_chat_member(chat_id::String, user_id::Int; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "user_id" => user_id)
    await send("kickChatMember", params; client=client)
end

async function ban_chat_member(chat_id::String, user_id::Int; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "user_id" => user_id)
    await send("banChatMember", params; client=client)
end

async function unban_chat_member(chat_id::String, user_id::Int; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "user_id" => user_id)
    await send("unbanChatMember", params; client=client)
end

async function approve_chat_join_request(chat_id::String, user_id::Int; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "user_id" => user_id)
    await send("approveChatJoinRequest", params; client=client)
end

async function decline_chat_join_request(chat_id::String, user_id::Int; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "user_id" => user_id)
    await send("declineChatJoinRequest", params; client=client)
end

async function answer_callback_query(callback_query_id::String; text::Union{String, Nothing}=nothing, show_alert::Bool=false, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("callback_query_id" => callback_query_id, "show_alert" => show_alert)
    if text !== nothing
        params["text"] = text
    end
    await send("answerCallbackQuery", params; client=client)
end

async function answer_inline_query(inline_query_id::String, results::Vector{Dict}; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("inline_query_id" => inline_query_id, "results" => JSON3.write(results))
    await send("answerInlineQuery", params; client=client)
end

async function get_chat_history(chat_id::String; limit::Int=100, offset::Int=0, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "limit" => limit, "offset" => offset)
    result = await send("getChatHistory", params; client=client)
    return [JSON3.read(JSON3.write(msg), Message) for msg in result]
end

async function get_dialogs(; limit::Int=100, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("limit" => limit)
    result = await send("getDialogs", params; client=client)
    return [JSON3.read(JSON3.write(dialog), Chat) for dialog in result]
end

async function set_parse_mode(mode::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    client.parse_mode = mode
end

async function get_parse_mode(; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    return get(client, :parse_mode, "HTML")
end

async function get_inline_bot_results(bot_id::String, query::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("bot_id" => bot_id, "query" => query)
    result = await send("getInlineBotResults", params; client=client)
    return result
end

async function send_inline_bot_result(chat_id::String, query_id::String, result_id::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "query_id" => query_id, "result_id" => result_id)
    result = await send("sendInlineBotResult", params; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_invoice(chat_id::String, title::String, description::String, payload::String, provider_token::String, currency::String, prices::Vector{Dict}; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "title" => title, "description" => description, "payload" => payload, "provider_token" => provider_token, "currency" => currency, "prices" => JSON3.write(prices))
    result = await send("sendInvoice", params; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_voice(voice_path::String; chat_id::Union{String, Nothing}=nothing, caption::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    chat_id = something(chat_id, client.chat_id)
    params = Dict("chat_id" => chat_id)
    if caption !== nothing
        params["caption"] = caption
    end
    files = Dict("voice" => open(voice_path, "r"))
    result = await send("sendVoice", params, files; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_video_note(video_note_path::String; chat_id::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    chat_id = something(chat_id, client.chat_id)
    params = Dict("chat_id" => chat_id)
    files = Dict("video_note" => open(video_note_path, "r"))
    result = await send("sendVideoNote", params, files; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_contact(chat_id::String, phone_number::String, first_name::String; last_name::Union{String, Nothing}=nothing, client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "phone_number" => phone_number, "first_name" => first_name)
    if last_name !== nothing
        params["last_name"] = last_name
    end
    result = await send("sendContact", params; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_location(chat_id::String, latitude::Float64, longitude::Float64; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "latitude" => latitude, "longitude" => longitude)
    result = await send("sendLocation", params; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_venue(chat_id::String, latitude::Float64, longitude::Float64, title::String, address::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "latitude" => latitude, "longitude" => longitude, "title" => title, "address" => address)
    result = await send("sendVenue", params; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_game(chat_id::String, game_short_name::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "game_short_name" => game_short_name)
    result = await send("sendGame", params; client=client)
    return JSON3.read(JSON3.write(result), Message)
end

async function send_chat_action(chat_id::String, action::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client)
    params = Dict("chat_id" => chat_id, "action" => action)
    await send("sendChatAction", params; client=client)
end

end
