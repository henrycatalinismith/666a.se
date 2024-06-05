require "rufus-scheduler"

# do not schedule when Rails is run from its console, for a test/spec, or from a
# Rake task
if defined?(Rails::Console) || Rails.env.test? ||
     File.split($PROGRAM_NAME).last == "rake" || Rails.env.development?
  return
end

scheduler = Rufus::Scheduler.singleton

scheduler.cron("0 9 * * *") do
  WorkEnvironment::MorningJob.perform_later(
    Date.yesterday.strftime("%Y-%m-%d"),
    cascade: true,
    notify: true
  )
end

scheduler.cron("0 10 * * *") do
  WorkEnvironment::DayJob.perform_later(
    2.days.ago.strftime("%Y-%m-%d"),
    cascade: true,
    force: true,
    notify: true,
    purge: true
  )
end

scheduler.cron("0 11 * * *") do
  WorkEnvironment::DayJob.perform_later(
    4.days.ago.strftime("%Y-%m-%d"),
    cascade: true,
    force: true,
    notify: true,
    purge: true
  )
end

# scheduler.cron("0 12 * * *") do
#   WorkEnvironment::DayJob.perform_later(
#     8.days.ago.strftime("%Y-%m-%d"),
#     cascade: true,
#     force: true,
#     notify: true,
#     purge: true
#   )
# end

# scheduler.cron("0 13 * * *") do
#   WorkEnvironment::DayJob.perform_later(
#     16.days.ago.strftime("%Y-%m-%d"),
#     cascade: true,
#     force: true,
#     notify: true,
#     purge: true
#   )
# end

# scheduler.cron("0 14 * * *") do
#   WorkEnvironment::DayJob.perform_later(
#     32.days.ago.strftime("%Y-%m-%d"),
#     cascade: true,
#     force: true,
#     notify: true,
#     purge: true
#   )
# end

# scheduler.cron("0 15 * * *") do
#   WorkEnvironment::DayJob.perform_later(
#     64.days.ago.strftime("%Y-%m-%d"),
#     cascade: true,
#     force: true,
#     notify: true,
#     purge: true
#   )
# end
