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

  # "K1",
  # "K1P1",
  # "K1P1S1",
  # "K1P2",
  # "K1P2S1",
  # "K1P2S2",
  # "K1P2S3",
  # "K1P2a",
  # "K1P2aS1",
  # "K1P2aS2",
  # "K1P2b",
  # "K1P2bS1",
  # "K1P2c",
  # "K1P2cS1",
  # "K1P3",
  # "K1P3S1",
  # "K1P3S2",
  # "K1P3S3"
  # "K3P7dS1",
  # "K3P7dS2",
  # "K3P7dS3",
  # "K3P7e",
  # "K3P7eS1",
  # "K3P7f",
  # "K3P7fS1",
  # "K3P7fS2",
  # "K3P7g",
  # "K3P7gS1",
  # "K3P7gS2",
  # "K3P7gS3",
  # "K3P7h",
  # "K3P7hS1",
  # "K3P8",
  # "K3P8S1",
  # "K3P8S2",
  # "K3P8S3",
  # "K3P9",
  # "K3P9S1",
  # "K3P9S2",
  # "K3P10",
  # "K3P10S1",
  # "K3P11",
  # "K3P11S1",
  # "K3P12",
  # "K3P12S1",
  # "K3P12S2",
  # "K3P13",
  # "K3P13S1",
  # "K3P14",

  task test: :environment do
    elements = Legal::Element.all
    elements.each do |element|
      chapter = element.element_code.match(/\AK([0-9])\Z/)
      chapter_paragraph = element.element_code.match(/\AK([0-9])P([0-9]+[a-z]?)\Z/)
      chapter_paragraph_section = element.element_code.match(/\AK([0-9])P([0-9]+[a-z]?)S([0-9]+)\Z/)
      paragraph = element.element_code.match(/\AP([0-9]+[a-z]?)\Z/)
      paragraph_section = element.element_code.match(/\AP([0-9]+[a-z]?)S([0-9]+)\Z/)
      if chapter then
        element.update(element_code: "chapter-#{chapter[1]}")
      elsif chapter_paragraph then
        element.update(element_code: "chapter-#{chapter_paragraph[1]}-paragraph-#{chapter_paragraph[2]}")
      elsif chapter_paragraph_section then
        element.update(element_code: "chapter-#{chapter_paragraph_section[1]}-paragraph-#{chapter_paragraph_section[2]}-section-#{chapter_paragraph_section[3]}")
      elsif paragraph then
        element.update(element_code: "paragraph-#{paragraph[1]}")
      elsif paragraph_section then
        element.update(element_code: "paragraph-#{paragraph_section[1]}-section-#{paragraph_section[2]}")
      end
    end
  end
end
