namespace :db do
  desc "Download production db"
  task download: :environment do
    sh "rm -f production.sqlite3"
    sh "fly sftp get /data/production.sqlite3"
    sh "cp production.sqlite3 db/development/data.sqlite3"
  end
end