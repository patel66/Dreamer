require 'spec_helper'

module DMR

  describe 'GetCyclesPerDay' do

    it "returns an error if the user is not found" do
      result = GetCyclesPerDay.run(session_id: 99)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:user_not_found)
    end

    it "returns an error if the day is not found" do
      user1 = DMR.db.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
      session = DMR.db.create_session(user1.id)
      result = GetCyclesPerDay.run({ session_id: session.id,
                                      creation_date: Time.new(1911, 2, 2) })
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:entry_not_found)
    end

    it "returns the entry for a specific date" do
      user1 = DMR.db.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
      session = DMR.db.create_session(user1.id)
      entry1 = DMR.db.create_sleep_entry({ user_id: user1.id, sleep_time: Time.new(2014, 4,13,20),
                       wake_time: Time.new(2014, 4,14,7,30) })
      result = GetCyclesPerDay.run({ session_id: session.id, date: Time.new(2014, 4,13) })

      expect(result.success?).to eq(true)
      expect(result.cycles).to eq(7)
    end


  end
end
