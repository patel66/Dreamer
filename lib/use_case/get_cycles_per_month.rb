require 'pry-debugger'


module DMR
  class GetCyclesPerMonth < UseCase

    def run(data)
      if !data[:start_date]
        start_date = Time.now - (7*24*60*60)
      else
        start_date = data[:start_date]
      end

      user = DMR.db.get_user_by_sid(data[:session_id])

      if user == nil then return failure(:user_not_found) end

      month_array = DMR.db.get_sleep_month(user.id, start_date)

      sum = 0
      month_array.each { |x| sum += CalculateCycles.run(x.sleep_time, x.wake_time) }
      return success :month_cycles => sum
    end

  end
end
