module DMR
  class GetJournalEntryByID(entry_id)
    return success (entry: DMR.db.get_journal_entry_by_id(entry_id))
  end
end
