module TelegramUtils

using ..TelegramTypes
using ..TelegramMethods

export create_inline_keyboard, create_reply_keyboard

function create_inline_keyboard(buttons::Vector{Vector{Tuple{String, String}}})
    inline_keyboard = InlineKeyboardButton[]
    for row in buttons
        row_buttons = InlineKeyboardButton[]
        for (text, callback_data) in row
            push!(row_buttons, InlineKeyboardButton(text, nothing, callback_data))
        end
        push!(inline_keyboard, row_buttons)
    end
    InlineKeyboardMarkup(inline_keyboard)
end

function create_reply_keyboard(buttons::Vector{Vector{String}}; resize_keyboard::Bool=true, one_time_keyboard::Bool=true)
    keyboard = Dict{String, Any}[]
    for row in buttons
        row_buttons = Dict{String, Any}[]
        for text in row
            push!(row_buttons, Dict("text" => text))
        end
        push!(keyboard, row_buttons)
    end
    ReplyKeyboardMarkup(keyboard, resize_keyboard, one_time_keyboard)
end

end
