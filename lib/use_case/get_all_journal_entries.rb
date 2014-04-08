module DMR
  class GetAllJournalEntries < UseCase
    def run(data)
      user = DMR.db.get_user_by_sid(data[:session_id])

      if user == nil
        return failure(:user_not_found)
      end

      entries = DMR.db.get_journal_entries_for_user(user.id)

      if entries.size == 0
        return failure(:no_entries_found)
      else
        return success :entries => entries
      end


    end
  end
end
