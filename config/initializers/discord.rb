require "discordrb"

if !ENV["DISCORD_BOT_AUTH_TOKEN"].nil? and !ENV["DISCORD_BOT_LOG_CHANNEL_ID"].nil? then

  bot = Discordrb::Bot.new token: ENV["DISCORD_BOT_AUTH_TOKEN"]

  #bot.send_message(ENV["DISCORD_BOT_LOG_CHANNEL_ID"], "`rails server starting`")

  #at_exit do
    #bot.send_message(ENV["DISCORD_BOT_LOG_CHANNEL_ID"], "`rails server stopping`")
  #end

  ActiveSupport::Notifications.subscribe("perform.active_job") do |event|

    if event.payload[:job].class == WorkEnvironment::MorningJob or 
      event.payload[:job].class == WorkEnvironment::SearchJob or
      event.payload[:job].class == WorkEnvironment::ResultJob then
      bot.send_message(ENV["DISCORD_BOT_LOG_CHANNEL_ID"], "`#{event.payload[:job].class} #{event.payload[:job].arguments.first}`")
    end

    if event.payload[:job].class == WorkEnvironment::DayJob then
      if event.payload[:job].arguments[1] then
        page = event.payload[:job].arguments[1][:page] || ""
      else
        page = ""
      end
      bot.send_message(ENV["DISCORD_BOT_LOG_CHANNEL_ID"], "`#{event.payload[:job].class} #{event.payload[:job].arguments.first} [#{page}]`")
    end

  end

end