module DMR

  class JournalEntry

    attr_accessor :user_id, :user_name, :creation_date, :title, :entry, :entry_type

    def initialize(data)
      @user_id = data[:user_id]
      @user_name = data[:user_name]
      @creation_date = data[:creation_date]
      @title = data[:title]
      @entry = data[:entry]
      @entry_type = data[:entry_type]

    end

  end

end
