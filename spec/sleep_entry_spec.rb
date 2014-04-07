require 'spec_helper'

module DMR
  describe SleepEntry do
    it "is initialized with an id, user_id, sleep_time, wake_time" do
      entry = SleepEntry.new({ user_id: 1, id: 3, sleep_time: Time.new(2014, 4,12,20,15),
                                wake_time: Time.new(2014, 4,13,7,30) })

    end

  end
end
