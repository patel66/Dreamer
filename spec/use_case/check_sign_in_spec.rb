require 'spec_helper'

module DMR
  describe 'CheckSignIn' do
    it "returns an error if the user is not signed in" do
      result = CheckSignIn.run(95)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:not_signed_in)
    end

    it "returns success if the user is signed in" do
      @user1 = DMR.db.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
      session = DMR.db.create_session(@user1.id)
      result = CheckSignIn.run(session.id)
      expect(result.success?).to eq(true)
    end
  end
end
