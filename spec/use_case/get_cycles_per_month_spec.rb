require 'spec_helper'

module DMR
  describe 'GetCyclesPerMonth' do
    it "returns an error if the user is not found" do
      result = GetCyclesPerMonth.run(session_id: 99)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:user_not_found)
    end

    it "returns the right number of sleep cycles for the user's week" do
      user1 = DMR.db.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
      current_sleep_time = Time.new(2010, 4,13,22)
      current_wake_time = Time.new(2010, 4,14,6)
      entries = []
      30.times do
        new_entry = DMR.db.create_sleep_entry({ user_id: user1.id, sleep_time: current_sleep_time,
                       wake_time: current_wake_time })
        entries << new_entry
        current_wake_time += (24*60*60)
        current_sleep_time += (24*60*60)
      end

      session = DMR.db.create_session(user1.id)
      result1 = GetCyclesPerMonth.run({ session_id: session.id, start_date: Time.new(2010,4,13) })
      result2 = GetCyclesPerMonth.run({ session_id: session.id, start_date: Time.new(2010,4,28) })

      expect(result1.month_cycles).to eq(150)
      expect(result2.month_cycles).to eq(75)


    end


  end



end
