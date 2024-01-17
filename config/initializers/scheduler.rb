require "rufus-scheduler"

# do not schedule when Rails is run from its console, for a test/spec, or from a
# Rake task
return if defined?(Rails::Console) || Rails.env.test? || File.split($PROGRAM_NAME).last == 'rake'

scheduler = Rufus::Scheduler.singleton

scheduler.cron("0 9 * * *") do
  WorkEnvironment::MorningJob.perform_later(Date.yesterday.strftime("%Y-%m-%d"), {
    :cascade => true,
    :notify => true,
  })
end

def day_job(hour, minute, date)
  scheduler.cron("#{minute} #{hour} * * *") do
    WorkEnvironment::DayJob.perform_later(
      date.strftime("%Y-%m-%d"),
      {
        :cascade => true,
        :force => true,
        :notify => true,
      }
    )
  end
end

day_job(10,  0, 2.days.ago)

day_job(11, 10, 3.days.ago)
day_job(11, 20, 4.days.ago)
day_job(11, 30, 5.days.ago)
day_job(11, 40, 6.days.ago)
day_job(11, 50, 7.days.ago)

day_job(12,  0, 8.days.ago)
day_job(12, 10, 9.days.ago)
day_job(12, 20, 10.days.ago)
day_job(12, 30, 11.days.ago)
day_job(12, 40, 12.days.ago)
day_job(12, 50, 13.days.ago)

day_job(13,  0, 14.days.ago)
day_job(13, 10, 15.days.ago)
day_job(13, 20, 16.days.ago)
day_job(13, 30, 17.days.ago)
day_job(13, 40, 18.days.ago)
day_job(13, 50, 19.days.ago)

day_job(14,  0, 20.days.ago)
day_job(14, 10, 21.days.ago)
day_job(14, 20, 22.days.ago)
day_job(14, 30, 23.days.ago)
day_job(14, 40, 24.days.ago)
day_job(14, 50, 25.days.ago)

day_job(15,  0, 26.days.ago)
day_job(15, 10, 27.days.ago)
day_job(15, 20, 28.days.ago)
day_job(15, 30, 29.days.ago)
day_job(15, 40, 30.days.ago)


# scheduler.cron("0 13 * * *") do
#   WorkEnvironment::BackfillJob.perform_later({
#     :cascade => true,
#     :notify => false,
#   })
# end

# scheduler.cron("0 15 * * *") do
#   WorkEnvironment::BackfillJob.perform_later({
#     :cascade => true,
#     :notify => false,
#   })
# end

# scheduler.cron("0 17 * * *") do
#   WorkEnvironment::BackfillJob.perform_later({
#     :cascade => true,
#     :notify => false,
#   })
# end

# scheduler.cron("0 19 * * *") do
#   WorkEnvironment::BackfillJob.perform_later({
#     :cascade => true,
#     :notify => false,
#   })
# end