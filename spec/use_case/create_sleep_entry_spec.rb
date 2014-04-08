require 'spec_helper'

module DMR
  describe 'create_sleep_entry' do
    before do
      @bob = DMR.db.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
      @session = DMR.db.create_session(@bob.id)
    end

    it "returns an error if the user is not found" do
      result = CreateSleepEntry.run({ user_id: 999, sleep_time: Time.new(2014, 4,13,20),
                                      wake_time: Time.new(2014, 4,13,7,30) })
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:user_not_found)
    end

    it "returns an error if the date is already filled" do
      entry = DMR.db.create_sleep_entry({ session_id: @session.id, user_id: @bob.id, sleep_time: Time.new(2014, 4,13,20),
                                      wake_time: Time.new(2014, 4,13,7,30) })
      result = CreateSleepEntry.run({ session_id: @session.id, sleep_time: Time.new(2014, 4,13,20),
                                      wake_time: Time.new(2014, 4,13,7,30) })
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:date_already_exists)
    end

    it "can create a sleep entry for a user" do
      result = CreateSleepEntry.run({ session_id: @session.id, user_id: @bob.id, sleep_time: Time.new(2014, 4,13,20),
                                      wake_time: Time.new(2014, 4,15,7,30) })
      expect(result.success?).to eq(true)
      expect(result.entry.user_id).to eq(@bob.id)
    end


  end

end
