require "rufus-scheduler"

# do not schedule when Rails is run from its console, for a test/spec, or from a Rake task
return if defined?(Rails::Console) || Rails.env.test? || File.split($PROGRAM_NAME).last == 'rake'

def big_scan(day, hour, minute)
  scheduler = Rufus::Scheduler.singleton
  scheduler.cron("#{minute} #{hour} * * *") do
    WorkEnvironment::MorningJob.perform_later(day.strftime("%Y-%m-%d"), {
      :cascade => true,
      :notify => true,
    })
  end
end

def topup_scan(day, hour, minute)
  scheduler = Rufus::Scheduler.singleton
  scheduler.cron("#{minute} #{hour} * * *") do
    WorkEnvironment::MorningJob.perform_later(day.strftime("%Y-%m-%d"), {
      :cascade => true,
      :force => true,
      :notify => true,
    })
  end
end

big_scan(1.day.ago, 9, 0)
topup_scan(2.days.ago, 10, 0)
topup_scan(3.days.ago, 10, 30)
topup_scan(4.days.ago, 11, 0)
topup_scan(5.days.ago, 11, 10)
topup_scan(6.days.ago, 11, 20)
topup_scan(7.days.ago, 11, 30)
topup_scan(8.days.ago, 11, 40)
topup_scan(9.days.ago, 11, 50)
topup_scan(10.days.ago, 12, 0)
topup_scan(11.days.ago, 12, 10)
topup_scan(12.days.ago, 12, 20)
topup_scan(13.days.ago, 12, 30)
topup_scan(14.days.ago, 12, 40)
topup_scan(15.days.ago, 12, 50)
topup_scan(16.days.ago, 13, 0)
topup_scan(17.days.ago, 13, 10)
topup_scan(18.days.ago, 13, 20)
topup_scan(19.days.ago, 13, 30)
topup_scan(20.days.ago, 13, 40)
topup_scan(21.days.ago, 13, 50)
topup_scan(22.days.ago, 14, 0)
topup_scan(23.days.ago, 14, 10)
topup_scan(24.days.ago, 14, 20)
topup_scan(25.days.ago, 14, 30)
topup_scan(26.days.ago, 14, 40)
topup_scan(27.days.ago, 14, 50)
topup_scan(28.days.ago, 15, 0)
topup_scan(29.days.ago, 15, 10)
topup_scan(30.days.ago, 15, 20)
topup_scan(31.days.ago, 15, 30)
topup_scan(32.days.ago, 15, 40)

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