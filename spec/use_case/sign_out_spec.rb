require 'spec_helper'

module DMR
  describe 'Sign Out' do

    it "returns an error if the session_id is not found" do
      result = SignOut.run(999)
      expect(result[:session_not_found])
    end

    it "signs the user out" do
      bob = DMR.db.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
      session = DMR.db.create_session(bob.id)
      result = SignOut.run(session.id)
      expect(DMR.db.get_user_by_sid(session.id)).to eq(nil)
    end
  end
end
