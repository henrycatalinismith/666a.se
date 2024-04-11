require "discordrb"

if !ENV["DISCORD_BOT_AUTH_TOKEN"].nil? and !ENV["DISCORD_BOT_LOG_CHANNEL_ID"].nil? then

  bot = Discordrb::Bot.new token: ENV["DISCORD_BOT_AUTH_TOKEN"]

  bot.send_message(ENV["DISCORD_BOT_LOG_CHANNEL_ID"], "`rails server starting`")

  at_exit do
    bot.send_message(ENV["DISCORD_BOT_LOG_CHANNEL_ID"], "`rails server stopping`")
  end

  jobs_to_notify = [
    WorkEnvironment::MorningJob,
    WorkEnvironment::DayJob,
    WorkEnvironment::SearchJob,
    WorkEnvironment::ResultJob,
  ]

  ActiveSupport::Notifications.subscribe("perform.active_job") do |event|
    if jobs_to_notify.include?(event.payload[:job].class) then
      bot.send_message(ENV["DISCORD_BOT_LOG_CHANNEL_ID"], "`#{event.payload[:job].class} #{event.payload[:job].arguments.first}`")
    end
  end

end