require 'pry-debugger'

module DMR
  class GetCyclesPerWeek < UseCase

    def run(data)
      if !data[:start_date]
        start_date = Time.now - (7*24*60*60)
      else
        start_date = data[:start_date]
      end

      user = DMR.db.get_user_by_sid(data[:session_id])

      if user == nil then return failure(:user_not_found) end

      week_array = DMR.db.get_sleep_week(user.id, start_date)
      sum = 0
      week_array.each { |x| sum += CalculateCycles.run(x.sleep_time, x.wake_time) }
      return success :week_hours => sum
    end
  end
end
