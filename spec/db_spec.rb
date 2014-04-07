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


  end
end
