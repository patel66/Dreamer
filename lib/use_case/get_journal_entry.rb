require 'pry-debugger'

module DMR
  class GetJournalEntry < UseCase
    def run(data)
      user = DMR.db.get_user_by_sid(data[:session_id])

      if user == nil
        return failure(:user_not_found)
      end

      entry = DMR.db.get_journal_entry(user.id, data[:date])

      if entry == nil
        return failure(:no_entries_found)
      else
        return success :entry => entry
      end
    end
  end
end
