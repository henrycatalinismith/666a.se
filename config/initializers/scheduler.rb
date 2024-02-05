require "rufus-scheduler"

# do not schedule when Rails is run from its console, for a test/spec, or from a
# Rake task
if defined?(Rails::Console) || Rails.env.test? ||
     File.split($PROGRAM_NAME).last == "rake"
  return
end

scheduler = Rufus::Scheduler.singleton

scheduler.cron("0 9 * * *") do
  WorkEnvironment::MorningJob.perform_later(
    Date.yesterday.strftime("%Y-%m-%d"),
    { cascade: true, notify: true }
  )
end

scheduler.cron("0 10 * * *") do
  WorkEnvironment::DayJob.perform_later(
    2.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("0 11 * * *") do
  WorkEnvironment::DayJob.perform_later(
    3.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("10 11 * * *") do
  WorkEnvironment::DayJob.perform_later(
    4.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("20 11 * * *") do
  WorkEnvironment::DayJob.perform_later(
    5.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("30 11 * * *") do
  WorkEnvironment::DayJob.perform_later(
    6.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("40 11 * * *") do
  WorkEnvironment::DayJob.perform_later(
    7.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("50 11 * * *") do
  WorkEnvironment::DayJob.perform_later(
    8.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("0 12 * * *") do
  WorkEnvironment::DayJob.perform_later(
    9.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("10 12 * * *") do
  WorkEnvironment::DayJob.perform_later(
    10.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("20 12 * * *") do
  WorkEnvironment::DayJob.perform_later(
    11.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("30 12 * * *") do
  WorkEnvironment::DayJob.perform_later(
    12.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("40 12 * * *") do
  WorkEnvironment::DayJob.perform_later(
    13.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("50 12 * * *") do
  WorkEnvironment::DayJob.perform_later(
    14.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("0 13 * * *") do
  WorkEnvironment::DayJob.perform_later(
    15.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("10 13 * * *") do
  WorkEnvironment::DayJob.perform_later(
    16.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("20 13 * * *") do
  WorkEnvironment::DayJob.perform_later(
    17.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("30 13 * * *") do
  WorkEnvironment::DayJob.perform_later(
    18.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("40 13 * * *") do
  WorkEnvironment::DayJob.perform_later(
    19.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("50 13 * * *") do
  WorkEnvironment::DayJob.perform_later(
    20.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("0 14 * * *") do
  WorkEnvironment::DayJob.perform_later(
    21.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end
scheduler.cron("10 14 * * *") do
  WorkEnvironment::DayJob.perform_later(
    22.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("20 14 * * *") do
  WorkEnvironment::DayJob.perform_later(
    23.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("30 14 * * *") do
  WorkEnvironment::DayJob.perform_later(
    24.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("40 14 * * *") do
  WorkEnvironment::DayJob.perform_later(
    25.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("50 14 * * *") do
  WorkEnvironment::DayJob.perform_later(
    26.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("0 15 * * *") do
  WorkEnvironment::DayJob.perform_later(
    27.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("10 15 * * *") do
  WorkEnvironment::DayJob.perform_later(
    28.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("20 16 * * *") do
  WorkEnvironment::DayJob.perform_later(
    29.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("30 16 * * *") do
  WorkEnvironment::DayJob.perform_later(
    30.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("40 16 * * *") do
  WorkEnvironment::DayJob.perform_later(
    31.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end

scheduler.cron("50 16 * * *") do
  WorkEnvironment::DayJob.perform_later(
    32.days.ago.strftime("%Y-%m-%d"),
    { cascade: true, force: true, notify: true }
  )
end
