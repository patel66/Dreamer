require 'spec_helper'

module DMR
  describe 'create_sleep_entry' do
    before do
      @bob = @db1.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
      @session = DMR.db.create_session(@bob.id)
    end

    it "returns an error if the date is already filled" do

    end

    xit "can create a sleep entry for a user" do
      result = DMR.CreateSleepEntry.run(@session.id)
      expect(result.success?).to eq(true)
    end


  end

end
