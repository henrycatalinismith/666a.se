require "rufus-scheduler"

# do not schedule when Rails is run from its console, for a test/spec, or from a
# Rake task
return if defined?(Rails::Console) || Rails.env.test? || File.split($PROGRAM_NAME).last == 'rake'

scheduler = Rufus::Scheduler.singleton
scheduler.cron("0 9 * * *") do
  MorningJob.perform_later(Date.yesterday.strftime("%Y-%m-%d"), true)
end
