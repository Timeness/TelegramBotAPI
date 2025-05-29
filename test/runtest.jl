using TelegramBotAPI
using Test

@testset "TelegramBotAPI Tests" begin
    client = TelegramClient("YOUR_BOT_TOKEN"; chat_id="YOUR_CHAT_ID")
    await start(client)

    @testset "Client Methods" begin
        user = await getMe()
        @test user.is_bot == true
    end

    @testset "Messaging Methods" begin
        msg = await send_message("Test message")
        @test msg.text == "Test message"
        await delete_messages(msg.chat.id, msg.message_id)
    end

    @testset "Handlers" begin
        dispatcher = Dispatcher(client)
        @on_message(command("test")) dispatcher function (msg, client)
            @test msg.text == "/test"
        end
        update = Update(1, Message(1, Chat(parse(Int64, client.chat_id), "private", nothing, nothing), 1234567890, "/test", nothing), nothing, nothing, nothing, nothing, nothing, nothing)
        await process_update(dispatcher, update)
    end

    await stop(client)
end
