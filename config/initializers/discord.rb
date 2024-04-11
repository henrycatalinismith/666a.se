require "discordrb"

if !ENV["DISCORD_BOT_AUTH_TOKEN"].nil? and !ENV["DISCORD_BOT_LOG_CHANNEL_ID"].nil? then

  bot = Discordrb::Bot.new token: ENV["DISCORD_BOT_AUTH_TOKEN"]

  bot.send_message(ENV["DISCORD_BOT_LOG_CHANNEL_ID"], "`rails server starting`")

  bot.ready do |event|
    bot.online
  end

  at_exit do
    bot.send_message(ENV["DISCORD_BOT_LOG_CHANNEL_ID"], "`rails server stopping`")
    bot.stop
  end

  ActiveSupport::Notifications.subscribe("perform.active_job") do |event|
    if event.payload[:job].class == WorkEnvironment::SearchJob then
      bot.send_message(ENV["DISCORD_BOT_LOG_CHANNEL_ID"], "`#{event.payload[:job].class} #{event.payload[:job].arguments.first}`")
    end
  end

  bot.run :async
end