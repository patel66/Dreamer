require 'spec_helper'

module DMR
  describe do

    it "returns an error if the user is not found" do
      result = GetCyclesPerWeek.run(session_id: 99)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:user_not_found)
    end

    it "returns the right number of sleep cycles for the user's week" do
      user1 = DMR.db.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
      entry1 = DMR.db.create_sleep_entry({ user_id: user1.id, sleep_time: Time.new(2014, 4,13,20),
                       wake_time: Time.new(2014, 4,14,7,30) })
      entry2 = DMR.db.create_sleep_entry({ user_id: user1.id, sleep_time: Time.new(2014, 4,14,20),
                       wake_time: Time.new(2014, 4,15,7,30) })
      entry3 = DMR.db.create_sleep_entry({ user_id: user1.id, sleep_time: Time.new(2014, 4,15,20),
                       wake_time: Time.new(2014, 4,16,7,30) })
      entry4 = DMR.db.create_sleep_entry({ user_id: user1.id, sleep_time: Time.new(2014, 4,16,20),
                       wake_time: Time.new(2014, 4,17,7,30) })
      entry5 = DMR.db.create_sleep_entry({ user_id: user1.id, sleep_time: Time.new(2014, 4,17,20),
                       wake_time: Time.new(2014, 4,18,7,30) })
      entry6 = DMR.db.create_sleep_entry({ user_id: user1.id, sleep_time: Time.new(2014, 4,18,20),
                       wake_time: Time.new(2014, 4,19,7,30) })
      entry7 = DMR.db.create_sleep_entry({ user_id: user1.id, sleep_time: Time.new(2014, 4,19,20),
                       wake_time: Time.new(2014, 4,20,7,30) })

      session = DMR.db.create_session(user1.id)
      result = GetCyclesPerWeek.run({ session_id: session.id, start_date: Time.new(2014,4,13,20) })
      expect(result.success?).to eq(true)
      expect(result.week_hours).to eq(49)
    end

  end
end


