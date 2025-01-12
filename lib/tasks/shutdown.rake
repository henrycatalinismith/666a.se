require "faker"

namespace :shutdown do
  task anonymize: :environment do
    user_accounts = User::Account.all
    user_accounts.each do |user|
      user.update(name: Faker::Name.name, email: Faker::Internet.email)
    end
  end
end
