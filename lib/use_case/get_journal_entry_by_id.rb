module DMR
  class GetJournalEntryByID < UseCase
    def run(entry_id)
      entry = DMR.db.get_journal_entry_by_id(entry_id)
      return success :entry => entry
    end
  end
end
