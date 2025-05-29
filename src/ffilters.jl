module TelegramFilters

using ..TelegramTypes
using Regex

export Filter, command, text, media, document, photo, audio, video, reply, sticker, private, group, channel, bot, regex

abstract type Filter end

struct CommandFilter <: Filter
    commands::Vector{String}
    prefix::String
end

struct TextFilter <: Filter
    text::String
end

struct MediaFilter <: Filter end

struct DocumentFilter <: Filter end

struct PhotoFilter <: Filter end

struct AudioFilter <: Filter end

struct VideoFilter <: Filter end

struct ReplyFilter <: Filter end

struct StickerFilter <: Filter end

struct PrivateFilter <: Filter end

struct GroupFilter <: Filter end

struct ChannelFilter <: Filter end

struct BotFilter <: Filter end

struct RegexFilter <: Filter
    pattern::Regex
end

command(commands::Union{String, Vector{String}}, prefix::String="/") = CommandFilter(commands isa String ? [commands] : commands, prefix)
text(text::String) = TextFilter(text)
media() = MediaFilter()
document() = DocumentFilter()
photo() = PhotoFilter()
audio() = AudioFilter()
video() = VideoFilter()
reply() = ReplyFilter()
sticker() = StickerFilter()
private() = PrivateFilter()
group() = GroupFilter()
channel() = ChannelFilter()
bot() = BotFilter()
regex(pattern::Regex) = RegexFilter(pattern)

function apply_filter(filter::CommandFilter, update::Update)
    update.message !== nothing && update.message.text !== nothing && any(cmd -> startswith(update.message.text, filter.prefix * cmd), filter.commands)
end

function apply_filter(filter::TextFilter, update::Update)
    update.message !== nothing && update.message.text == filter.text
end

function apply_filter(filter::MediaFilter, update::Update)
    update.message !== nothing && (update.message.photo !== nothing || update.message.document !== nothing || update.message.audio !== nothing || update.message.video !== nothing || update.message.animation !== nothing || update.message.sticker !== nothing)
end

function apply_filter(filter::DocumentFilter, update::Update)
    update.message !== nothing && update.message.document !== nothing
end

function apply_filter(filter::PhotoFilter, update::Update)
    update.message !== nothing && update.message.photo !== nothing
end

function apply_filter(filter::AudioFilter, update::Update)
    update.message !== nothing && update.message.audio !== nothing
end

function apply_filter(filter::VideoFilter, update::Update)
    update.message !== nothing && update.message.video !== nothing
end

function apply_filter(filter::ReplyFilter, update::Update)
    update.message !== nothing && update.message.reply_to_message !== nothing
end

function apply_filter(filter::StickerFilter, update::Update)
    update.message !== nothing && update.message.sticker !== nothing
end

function apply_filter(filter::PrivateFilter, update::Update)
    update.message !== nothing && update.message.chat.type == "private"
end

function apply_filter(filter::GroupFilter, update::Update)
    update.message !== nothing && update.message.chat.type == "group"
end

function apply_filter(filter::ChannelFilter, update::Update)
    update.message !== nothing && update.message.chat.type == "channel"
end

function apply_filter(filter::BotFilter, update::Update)
    update.message !== nothing && update.message.from !== nothing && update.message.from.is_bot
end

function apply_filter(filter::RegexFilter, update::Update)
    update.message !== nothing && update.message.text !== nothing && occursin(filter.pattern, update.message.text)
end

end
