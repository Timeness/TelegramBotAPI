module TelegramIterators

using ..TelegramTypes
using ..TelegramMethods

export iter_chat_members, iter_chat_messages, iter_dialogs, iter_history

struct ChatMembersIterator
    chat_id::String
    client::TelegramClient
    offset::Int
    limit::Int
end

struct ChatMessagesIterator
    chat_id::String
    client::TelegramClient
    offset::Int
    limit::Int
end

struct DialogsIterator
    client::TelegramClient
    offset::Int
    limit::Int
end

struct HistoryIterator
    chat_id::String
    client::TelegramClient
    offset::Int
    limit::Int
end

iter_chat_members(chat_id::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client, limit::Int=100) = ChatMembersIterator(chat_id, client, 0, limit)
iter_chat_messages(chat_id::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client, limit::Int=100) = ChatMessagesIterator(chat_id, client, 0, limit)
iter_dialogs(; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client, limit::Int=100) = DialogsIterator(client, 0, limit)
iter_history(chat_id::String; client::Union{TelegramClient, Nothing}=GLOBAL_CLIENT.client, limit::Int=100) = HistoryIterator(chat_id, client, 0, limit)

async function Base.iterate(iter::ChatMembersIterator, state=nothing)
    members = await get_chat_members(iter.chat_id; client=iter.client)
    if isempty(members)
        return nothing
    end
    iter.offset += iter.limit
    return members, iter.offset
end

async function Base.iterate(iter::ChatMessagesIterator, state=nothing)
    messages = await get_messages(iter.chat_id, collect(iter.offset+1:iter.offset+iter.limit); client=iter.client)
    if isempty(messages)
        return nothing
    end
    iter.offset += iter.limit
    return messages, iter.offset
end

async function Base.iterate(iter::DialogsIterator, state=nothing)
    dialogs = await get_dialogs(limit=iter.limit; client=iter.client)
    if isempty(dialogs)
        return nothing
    end
    iter.offset += iter.limit
    return dialogs, iter.offset
end

async function Base.iterate(iter::HistoryIterator, state=nothing)
    messages = await get_chat_history(iter.chat_id, limit=iter.limit, offset=iter.offset; client=iter.client)
    if isempty(messages)
        return nothing
    end
    iter.offset += iter.limit
    return messages, iter.offset
end

end
