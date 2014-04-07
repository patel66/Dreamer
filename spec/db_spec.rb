require 'spec_helper'

module DMR
  describe DB do
    before do
      @db1 = DMR.db
    end

    it "can create a user and add them to the database" do
      bob = @db1.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
      expect(@db1.get_user(bob.id).email).to eq("bob@bob.com")
      expect(@db1.get_user(bob.id).password).to eq("password")
      expect(@db1.get_user(bob.id).full_name).to eq("Bob Bobberson")
      expect(@db1.get_user(bob.id).birthdate).to eq(Time.new(1990,1,1))
      expect(@db1.get_user(bob.id).phone).to eq("512-791-4819")
      expect(@db1.get_user(bob.id).id).to eq(bob.id)
    end

    before do
      @user1 = @db1.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
    end

    it "can create a session and return the user from the session_id" do
      session = @db1.create_session(@user1.id)
      expect(@db1.get_user_by_sid(session.id).id).to eq(@user1.id)
    end

    it "can create a sleep_entry and retrieve it from the db" do

      entry1 = @db1.create_sleep_entry({ user_id: 1, sleep_time: Time.new(2014, 4,13,20),
                                      wake_time: Time.new(2014, 4,13,7,30) })
      expect(@db1.get_sleep_entry(entry1.id).id).to eq(entry1.id)
    end

    before do
      @entry1 = @db1.create_sleep_entry({ user_id: 1, sleep_time: Time.new(2014, 4,13,20),
                       wake_time: Time.new(2014, 4,14,7,30) })
      @entry2 = @db1.create_sleep_entry({ user_id: 1, sleep_time: Time.new(2014, 4,14,20),
                       wake_time: Time.new(2014, 4,15,7,30) })
      @entry3 = @db1.create_sleep_entry({ user_id: 1, sleep_time: Time.new(2014, 4,15,20),
                       wake_time: Time.new(2014, 4,16,7,30) })
      @entry4 = @db1.create_sleep_entry({ user_id: 2, sleep_time: Time.new(2014, 4,13,20),
                       wake_time: Time.new(2014, 4,14,7,30) })
      @entry5 = @db1.create_sleep_entry({ user_id: 2, sleep_time: Time.new(2014, 4,14,20),
                       wake_time: Time.new(2014, 4,15,7,30) })
    end

    it "can return a list of all sleep entries for a user" do
      entries_list = @db1.get_sleep_entries_by_user(1)
      expect(entries_list.size).to eq(3)
      expect(entries_list.first.sleep_time).to eq(Time.new(2014, 4,13,20))
      expect(entries_list.last.wake_time).to eq(Time.new(2014, 4,16,7,30))
    end

  end
end
