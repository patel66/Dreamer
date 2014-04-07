require 'spec_helper'

module DMR
  describe 'Sign Up' do
    it "returns an error if the email is already taken" do
      user1 = DMR.db.create_user({ password: "password",
                            full_name: "Bob Bobberson", email: "bob@bob.com",
                            birthdate: Time.new(1990, 1, 1),
                            phone: "512-791-4819" })
      result = SignUp.run({ password: "password",
                            full_name: "Bob Bobberson", email: "bob@bob.com",
                            birthdate: Time.new(1990, 1, 1),
                            phone: "512-791-4819" })
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:email_taken)
    end

    it "creates the user and signs them in" do
      result = SignUp.run({ password: "password",
                            full_name: "Bob Bobberson", email: "bob@bob.com",
                            birthdate: Time.new(1990, 1, 1),
                            phone: "512-791-4819" })
      expect(result.success?).to eq(true)
      expect(result.session_id).to be_a(Fixnum)
    end


  end
end
