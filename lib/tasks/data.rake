namespace :data do
  desc "Dump development sqlite database to db/data.sql."
  task :dump do
    print "Dumping db/development.sqlite3 to db/data.sql..."
    `sqlite3 "#{Rails.root}/db/development.sqlite3" ".dump" | grep '^INSERT' | grep -v schema_migrations > "#{Rails.root}/db/data.sql"`
    puts "Done."
  end

  desc "Load development sqlite database from db/data.sql."
  task :load do
    print "Loading db/development.sqlite3 from db/data.sql..."
    `sqlite3 "#{Rails.root}/db/development.sqlite3" ".read #{Rails.root}/db/data.sql"`
    puts "Done."
  end
end
