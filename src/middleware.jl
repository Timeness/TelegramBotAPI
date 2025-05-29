module TelegramMiddleware

using ..TelegramTypes

export Middleware, apply_middleware

struct Middleware
    before::Union{Function, Nothing}
    after::Union{Function, Nothing}
end

async function apply_middleware(middleware::Middleware, update::Update, handler::Function, client::TelegramClient)
    if middleware.before !== nothing
        await middleware.before(update, client)
    end
    await handler(update, client)
    if middleware.after !== nothing
        await middleware.after(update, client)
    end
end

end
