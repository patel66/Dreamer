require 'spec_helper'

module DMR
  describe 'SignIn' do

    before do
      @user1 = DMR.db.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
    end

    it "Returns an error if the user is not found" do
      result = SignIn.run({ email: "nothere@notfound.com", password: "password" })
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:email_not_found)
    end

    it "Returns an error if the password is incorrect" do
      result = SignIn.run({ email: "bob@bob.com", password: "NOTtherightpassword" })
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:incorrect_password)
    end

    it "Creates a session and returns a session_id" do
      result = SignIn.run({ email: "bob@bob.com", password: "password" })
      expect(result.success?).to eq(true)
      expect(result.session_id).to be_a(Fixnum)
    end




  end
end
