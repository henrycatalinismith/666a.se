require "discordrb"

if !ENV["DISCORD_BOT_AUTH_TOKEN"].nil? and
     !ENV["DISCORD_BOT_LOG_CHANNEL_ID"].nil?
  bot = Discordrb::Bot.new token: ENV["DISCORD_BOT_AUTH_TOKEN"]

  #bot.send_message(ENV["DISCORD_BOT_LOG_CHANNEL_ID"], "`rails server starting`")

  #at_exit do
  #bot.send_message(ENV["DISCORD_BOT_LOG_CHANNEL_ID"], "`rails server stopping`")
  #end

  ActiveSupport::Notifications.subscribe("perform.active_job") do |event|
    if event.payload[:job].class == WorkEnvironment::DayJob
      bot.send_message(
        ENV["DISCORD_BOT_LOG_CHANNEL_ID"],
        "`#{event.payload[:job].class} #{event.payload[:job].arguments.first}`"
      )
    end
  end
end
