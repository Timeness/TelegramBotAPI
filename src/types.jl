module TelegramTypes

using JSON3
using StructTypes

export User, Chat, Message, InlineKeyboardButton, InlineKeyboardMarkup, ReplyKeyboardMarkup, ReplyKeyboardRemove, ForceReply, CallbackQuery, InlineQuery, Poll, ChatMember, PhotoSize, ChatJoinRequest, PreCheckoutQuery, SuccessfulPayment

struct User
    id::Int64
    is_bot::Bool
    first_name::String
    last_name::Union{String, Nothing}
    username::Union{String, Nothing}
end
StructTypes.StructType(::Type{User}) = StructTypes.Struct()

struct Chat
    id::Int64
    type::String
    title::Union{String, Nothing}
    username::Union{String, Nothing}
end
StructTypes.StructType(::Type{Chat}) = StructTypes.Struct()

struct Message
    message_id::Int64
    chat::Chat
    date::Int64
    text::Union{String, Nothing}
    from::Union{User, Nothing}
    photo::Union{Vector{PhotoSize}, Nothing}
    document::Union{Dict, Nothing}
    audio::Union{Dict, Nothing}
    video::Union{Dict, Nothing}
    animation::Union{Dict, Nothing}
    sticker::Union{Dict, Nothing}
    poll::Union{Poll, Nothing}
    reply_to_message::Union{Message, Nothing}
end
StructTypes.StructType(::Type{Message}) = StructTypes.Struct()

struct PhotoSize
    file_id::String
    file_unique_id::String
    width::Int
    height::Int
    file_size::Union{Int, Nothing}
end
StructTypes.StructType(::Type{PhotoSize}) = StructTypes.Struct()

struct InlineKeyboardButton
    text::String
    url::Union{String, Nothing}
    callback_data::Union{String, Nothing}
end
StructTypes.StructType(::Type{InlineKeyboardButton}) = StructTypes.Struct()

struct InlineKeyboardMarkup
    inline_keyboard::Vector{Vector{InlineKeyboardButton}}
end
StructTypes.StructType(::Type{InlineKeyboardMarkup}) = StructTypes.Struct()

struct ReplyKeyboardMarkup
    keyboard::Vector{Vector{Dict}}
    resize_keyboard::Union{Bool, Nothing}
    one_time_keyboard::Union{Bool, Nothing}
end
StructTypes.StructType(::Type{ReplyKeyboardMarkup}) = StructTypes.Struct()

struct ReplyKeyboardRemove
    remove_keyboard::Bool
end
StructTypes.StructType(::Type{ReplyKeyboardRemove}) = StructTypes.Struct()

struct ForceReply
    force_reply::Bool
end
StructTypes.StructType(::Type{ForceReply}) = StructTypes.Struct()

struct CallbackQuery
    id::String
    from::User
    message::Union{Message, Nothing}
    data::Union{String, Nothing}
end
StructTypes.StructType(::Type{CallbackQuery}) = StructTypes.Struct()

struct InlineQuery
    id::String
    from::User
    query::String
end
StructTypes.StructType(::Type{InlineQuery}) = StructTypes.Struct()

struct Poll
    id::String
    question::String
    options::Vector{Dict{String, Any}}
end
StructTypes.StructType(::Type{Poll}) = StructTypes.Struct()

struct ChatMember
    user::User
    status::String
end
StructTypes.StructType(::Type{ChatMember}) = StructTypes.Struct()

struct ChatJoinRequest
    chat::Chat
    from::User
    date::Int64
end
StructTypes.StructType(::Type{ChatJoinRequest}) = StructTypes.Struct()

struct PreCheckoutQuery
    id::String
    from::User
    currency::String
    total_amount::Int
end
StructTypes.StructType(::Type{PreCheckoutQuery}) = StructTypes.Struct()

struct SuccessfulPayment
    currency::String
    total_amount::Int
    invoice_payload::String
end
StructTypes.StructType(::Type{SuccessfulPayment}) = StructTypes.Struct()

struct Update
    update_id::Int64
    message::Union{Message, Nothing}
    callback_query::Union{CallbackQuery, Nothing}
    inline_query::Union{InlineQuery, Nothing}
    poll::Union{Poll, Nothing}
    chat_join_request::Union{ChatJoinRequest, Nothing}
    pre_checkout_query::Union{PreCheckoutQuery, Nothing}
    successful_payment::Union{SuccessfulPayment, Nothing}
end
StructTypes.StructType(::Type{Update}) = StructTypes.Struct()

end
