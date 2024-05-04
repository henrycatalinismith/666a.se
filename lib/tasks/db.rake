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

  task zip: :environment do
    timestamp = Time.now.strftime("%Y%m%d.%H%M%S")
    sh "zip -r 'backups/db.#{timestamp}.zip' db/development/data.sqlite3 db/development/data.sqlite3-shm db/development/data.sqlite3-wal"
  end

  task backup: :environment do
    zip_files = Dir.glob("backups/*.zip")
    zip_files.each do |zip_file|
      FileUtils.mv(zip_file, "/Volumes/Samsung/666a")
    end
  end

  task rotate: :environment do
    files = Dir.glob("/Volumes/Samsung/666a/*")
    if files.length > 4
      oldest_file = files.min_by { |file| File.mtime(file) }
      File.delete(oldest_file)
    end
  end

  task cron: %i[download zip backup rotate]
end
