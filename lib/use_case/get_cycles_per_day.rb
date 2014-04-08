module DMR
  class GetCyclesPerDay < UseCase
    def run(data)

      user = DMR.db.get_user_by_sid(data[:session_id])

      if user == nil then return failure(:user_not_found) end

      entry = DMR.db.get_sleep_entry_by_user_and_date(user.id, data[:date])

      if entry == nil
        return failure(:entry_not_found)
      else
        return success :cycles => (CalculateCycles.run(entry.sleep_time,
                                        entry.wake_time))

      end
    end
  end
end
