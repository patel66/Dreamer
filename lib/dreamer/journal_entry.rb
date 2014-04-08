module DMR

  class JournalEntry

    attr_accessor :user_id, :creation_date, :title, :entry, :entry_type, :id

    def initialize(data)
      @user_id = data[:user_id]
      @creation_date = data[:creation_date]
      @title = data[:title]
      @entry = data[:entry]
      @entry_type = data[:entry_type]
      @id = data[:id]

    end

  end

end
