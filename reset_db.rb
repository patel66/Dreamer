# USAGE:
# $ bundle exec ruby reset-db.rb
#
# You can also specify a database:
# $ bundle exec ruby reset_db.rb my-app.db
require "sqlite3"

db_name = ARGV[0] || "dmr_test.db"
sqlite = SQLite3::Database.new(db_name)

puts "Destroying #{db_name}..."
sqlite.execute %q{DROP TABLE IF EXISTS journal_entries}
sqlite.execute %q{DROP TABLE IF EXISTS sleep_entries}
sqlite.execute %q{DROP TABLE IF EXISTS users}
sqlite.execute %q{DROP TABLE IF EXISTS sessions}

puts "Creating tables..."


sqlite.execute %q{
  CREATE TABLE users(
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    email       TEXT    NOT NULL,
    password    TEXT    NOT NULL,
    full_name   TEXT    NOT NULL,
    birthdate   INT    NOT NULL,
    phone       TEXT    NOT NULL
    );
}

sqlite.execute %q{
    CREATE TABLE journal_entries(
      id          INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id     INT,
      entry_type  TEXT,
      title       TEXT,
      entry       TEXT,
      creation_date INT
  );
}

sqlite.execute %q{
    CREATE TABLE sleep_entries(
      id          INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id     INT,
      sleep_time  INT,
      wake_time   INT
  );
}

sqlite.execute %q{
  CREATE TABLE sessions(
      id        INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id   INT
  );
}


puts "Database Schema:\n\n"
puts `echo .schema | sqlite3 #{db_name}`
