module DMR
  class CreateJournalEntry < UseCase
    def run(data)
      user = DMR.db.get_user_by_sid(data[:session_id])
      entry = DMR.db.get_journal_entry(user.id, data[:creation_date])
      if entry != nil
        return failure(:date_already_filled)
      else
        entry = DMR.db.create_journal_entry({ user_id: user.id, title: data[:title],
                                              entry: data[:entry], create_date: Time.now,
                                                entity_type: "night" })
        return success :entry => entry
      end

    end

  end
end
