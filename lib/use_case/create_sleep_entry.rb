module DMR
  class CreateSleepEntry < UseCase
    def run(data)
      user = DMR.db.get_user_by_sid(data[:session_id])

      if user == nil
        return failure(:user_not_found)
      end

      entry = DMR.db.get_sleep_entry_by_user_and_date(user.id, data[:sleep_time])

      if entry != nil
        return failure(:date_already_exists)
      end

      entry = DMR.db.create_sleep_entry(data)

      return success :entry => entry
    end
  end
end
