require "slack-ruby-client"

if !ENV["SLACK_API_TOKEN"].nil? and
     !ENV["SLACK_CHANNEL_ID"].nil? and Rails.env.production?

  Slack.configure do |config|
    config.token = ENV["SLACK_API_TOKEN"]
  end

  client = Slack::Web::Client.new
  client.auth_test

  ActiveSupport::Notifications.subscribe("perform.active_job") do |event|
    if event.payload[:job].class == WorkEnvironment::DayJob
      client.chat_postMessage(
        channel: ENV["SLACK_CHANNEL_ID"],
        text: "`#{event.payload[:job].class} #{event.payload[:job].arguments.first}`"
        as_user: true
      )
    end
  end
end
