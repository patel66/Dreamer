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
      session_id = @sqlite.execute("SELECT last_insert_rowid()")
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

    def create_journal_entry()



  end
end
