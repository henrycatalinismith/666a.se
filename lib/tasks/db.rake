namespace :db do

  desc "Download production database"
  task download: :environment do
    sh "fly sftp get /data/production/data.sqlite3"
    sh "fly sftp get /data/production/data.sqlite3-shm"
    sh "fly sftp get /data/production/data.sqlite3-wal"
    sh "mv data.sqlite3 db/development/data.sqlite3"
    sh "mv data.sqlite3-shm db/development/data.sqlite3-shm"
    sh "mv data.sqlite3-wal db/development/data.sqlite3-wal"
  end

  desc "Upload development database"
  task upload: :environment do
    # IO.popen("fly sftp shell", "r+") do |io|
    #   puts io.gets
    #   io.puts("ls")
    #   puts io.gets
    # end
  end
end