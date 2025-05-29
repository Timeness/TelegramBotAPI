module TelegramHandlers

using ..TelegramTypes
using ..TelegramMethods
using ..TelegramFilters

export Dispatcher, Handler, MessageHandler, CallbackQueryHandler, InlineQueryHandler, ChatJoinRequestHandler, PreCheckoutQueryHandler, SuccessfulPaymentHandler, add_handler!, on_message, on_callback_query, on_inline_query, on_chat_join_request, on_pre_checkout_query, on_successful_payment

abstract type Handler end

struct MessageHandler <: Handler
    callback::Function
    filters::Vector{Filter}
end

struct CallbackQueryHandler <: Handler
    callback::Function
    filters::Vector{Filter}
end

struct InlineQueryHandler <: Handler
    callback::Function
    filters::Vector{Filter}
end

struct ChatJoinRequestHandler <: Handler
    callback::Function
    filters::Vector{Filter}
end

struct PreCheckoutQueryHandler <: Handler
    callback::Function
    filters::Vector{Filter}
end

struct SuccessfulPaymentHandler <: Handler
    callback::Function
    filters::Vector{Filter}
end

mutable struct Dispatcher
    client::TelegramClient
    handlers::Vector{Handler}
end

Dispatcher(client::TelegramClient) = Dispatcher(client, Handler[])

function add_handler!(dispatcher::Dispatcher, handler::Handler)
    push!(dispatcher.handlers, handler)
    return dispatcher
end

macro on_message(filters...)
    quote
        (dispatcher::Dispatcher, callback::Function) -> begin
            add_handler!(dispatcher, MessageHandler(callback, [$(filters...)]))
            dispatcher
        end
    end
end

macro on_callback_query(filters...)
    quote
        (dispatcher::Dispatcher, callback::Function) -> begin
            add_handler!(dispatcher, CallbackQueryHandler(callback, [$(filters...)]))
            dispatcher
        end
    end
end

macro on_inline_query(filters...)
    quote
        (dispatcher::Dispatcher, callback::Function) -> begin
            add_handler!(dispatcher, InlineQueryHandler(callback, [$(filters...)]))
            dispatcher
        end
    end
end

macro on_chat_join_request(filters...)
    quote
        (dispatcher::Dispatcher, callback::Function) -> begin
            add_handler!(dispatcher, ChatJoinRequestHandler(callback, [$(filters...)]))
            dispatcher
        end
    end
end

macro on_pre_checkout_query(filters...)
    quote
        (dispatcher::Dispatcher, callback::Function) -> begin
            add_handler!(dispatcher, PreCheckoutQueryHandler(callback, [$(filters...)]))
            dispatcher
        end
    end
end

macro on_successful_payment(filters...)
    quote
        (dispatcher::Dispatcher, callback::Function) -> begin
            add_handler!(dispatcher, SuccessfulPaymentHandler(callback, [$(filters...)]))
            dispatcher
        end
    end
end

async function process_update(dispatcher::Dispatcher, update::Update)
    for handler in dispatcher.handlers
        if handler isa MessageHandler && update.message !== nothing
            if isempty(handler.filters) || all(f -> apply_filter(f, update), handler.filters)
                @async handler.callback(update.message, dispatcher.client)
            end
        elseif handler isa CallbackQueryHandler && update.callback_query !== nothing
            if isempty(handler.filters) || all(f -> apply_filter(f, update), handler.filters)
                @async handler.callback(update.callback_query, dispatcher.client)
            end
        elseif handler isa InlineQueryHandler && update.inline_query !== nothing
            if isempty(handler.filters) || all(f -> apply_filter(f, update), handler.filters)
                @async handler.callback(update.inline_query, dispatcher.client)
            end
        elseif handler isa ChatJoinRequestHandler && update.chat_join_request !== nothing
            if isempty(handler.filters) || all(f -> apply_filter(f, update), handler.filters)
                @async handler.callback(update.chat_join_request, dispatcher.client)
            end
        elseif handler isa PreCheckoutQueryHandler && update.pre_checkout_query !== nothing
            if isempty(handler.filters) || all(f -> apply_filter(f, update), handler.filters)
                @async handler.callback(update.pre_checkout_query, dispatcher.client)
            end
        elseif handler isa SuccessfulPaymentHandler && update.successful_payment !== nothing
            if isempty(handler.filters) || all(f -> apply_filter(f, update), handler.filters)
                @async handler.callback(update.successful_payment, dispatcher.client)
            end
        end
    end
end

end
