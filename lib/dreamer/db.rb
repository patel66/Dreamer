require 'pry-debugger'

module DMR


  def self.db_name=(db_name)
    @app_db_name = db_name
  end

  def self.db
    @__db_instance ||= DB.new(@app_db_name)
  end

  class DB
    def initialize(db_name)
      raise StandardError.new("Please set DMR.db_name") if db_name.nil?
      @sqlite = SQLite3::Database.new(db_name)
    end

    def create_user(data)
      new_user = User.new(data)
      @sqlite.execute("INSERT INTO users (email, password, full_name, birthdate, phone) VALUES(?,?,?,?,?)",
              data[:email], data[:password], data[:full_name], data[:birthdate].to_i, data[:phone])
      new_user.id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]
      new_user
    end

    def get_user(user_id)
      rows = @sqlite.execute("SELECT * FROM users WHERE id = ?", user_id)
      result = rows.first
      user = User.new({ email: result[1], password: result[2],
        full_name: result[3], birthdate: Time.at(result[4]), phone: result[5],
        id: result[0] })
      user
    end

    def create_session(user_id)
      @sqlite.execute("INSERT INTO sessions (user_id) VALUES(?)", user_id)
      session_id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]
      new_session = Session.new(session_id, user_id)
      return new_session
    end

    def get_user_by_sid(session_id)
      result = @sqlite.execute("SELECT user_id FROM sessions WHERE id = ?", session_id)
      if result.size == 0
        return nil
      else
        return self.get_user(result[0][0])
      end
    end

    def create_sleep_entry(data)
      @sqlite.execute("INSERT INTO sleep_entries (user_id, sleep_time, wake_time) VALUES (?,?,?)",
               data[:user_id], data[:sleep_time].to_i, data[:wake_time].to_i)
      sleep_entry_id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]
      entry = SleepEntry.new({ user_id: data[:user_id], sleep_time: data[:sleep_time],
                                wake_time: data[:wake_time], id: sleep_entry_id })
      entry
    end

    def get_sleep_entry(entry_id)
      rows = @sqlite.execute("SELECT * FROM sleep_entries WHERE id = ?", entry_id)
      if rows.size == 0
        return nil
      else
        result = rows[0]
        entry = SleepEntry.new({ id: result[0], user_id: result[1], sleep_time: result[2], wake_time: result[3] })
      end
      entry
    end

    def get_sleep_entries_by_user(user_id)
      result = @sqlite.execute("SELECT * FROM sleep_entries WHERE user_id = ?", user_id)
      result.map do |row|
        entry = SleepEntry.new({ user_id: row[1], id: row[0], sleep_time: Time.at(row[2]), wake_time: Time.at(row[3]) })
        entry
      end
    end

    def get_user_by_email(email)
      rows = @sqlite.execute("SELECT * FROM users WHERE email = ?", email)
      if rows.size == 0
        return nil
      else
        result = rows.first
        user = User.new({ email: result[1], password: result[2],
            full_name: result[3], birthdate: Time.at(result[4]), phone: result[5],
            id: result[0] })
        user
      end
    end

    def get_sleep_entry_by_user_and_date(user_id, date)
      entries = self.get_sleep_entries_by_user(user_id)
      entries.select! { |x| x.sleep_time.strftime("%y/%m/%d") == date.strftime("%y/%m/%d") }
      return entries.first
    end

    def get_sleep_week(user_id, date)
      entries = self.get_sleep_entries_by_user(user_id)
      entries.select { |x| (x.sleep_time >= date) && (x.sleep_time <= (date + (7*24*60*60))) }
    end

    def get_sleep_month(user_id, date)
      entries = self.get_sleep_entries_by_user(user_id)
      entries.select { |x| (x.sleep_time >= date) && (x.sleep_time <= (date + (30*24*60*60))) }
    end


    def clear_all_records
      @sqlite.execute("DELETE FROM users")
      @sqlite.execute("DELETE FROM journal_entries")
      @sqlite.execute("DELETE FROM sleep_entries")
      @sqlite.execute("DELETE FROM sessions")
    end

    def create_journal_entry(data)
      @sqlite.execute("INSERT INTO journal_entries (user_id, entry_type, title, entry, creation_date) VALUES (?,?,?,?,?)",
                      data[:user_id], data[:entry_type], data[:title], data[:entry], data[:creation_date].to_i)
      entry = JournalEntry.new(data)
      entry.id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]
      entry
    end

    def get_journal_entries_for_user(user_id)
      result = @sqlite.execute("SELECT * FROM journal_entries WHERE user_id = ?", user_id)
      result.map do |row|
        entry = JournalEntry.new({ user_id: row[1],
                                   creation_date: Time.at(row[5]),
                                  title: row[3],
                                  entry: row[4],
                                  entry_type: row[2],
                                  id: row[0] })
        entry
      end
    end

    def get_journal_entry(user_id, creation_date)
      result = self.get_journal_entries_for_user(user_id)
      result.select! { |x| x.creation_date.strftime("%y/%m/%d") == creation_date.strftime("%y/%m/%d") }
      result.first
    end

  end
end
