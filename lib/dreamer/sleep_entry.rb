module DMR
  class SleepEntry

    attr_accessor :id, :user_id, :sleep_time, :wake_time

    def initialize(data)
      @user_id = data[:user_id]
      @id = data[:id]
      @sleep_time = data[:sleep_time]
      @wake_time = data[:wake_time]
    end


  end
end
