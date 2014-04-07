require 'spec_helper'

module DMR
  describe User do
    it "is initialized with password, fullname, birthdate, phone" do
      bob = User.new({ username: "Bob", password: "password",
                        full_name: "Bob Bobberson", email: "bob@bob.com",
                        birthdate: Time.new(1990, 1, 1),
                        phone: "512-791-4819", id: 1 })
      expect(bob.password).to eq("password")
      expect(bob.full_name).to eq("Bob Bobberson")
      expect(bob.email).to eq("bob@bob.com")
      expect(bob.phone).to eq("512-791-4819")
      expect(bob.birthdate).to eq(Time.new(1990, 1, 1))
      expect(bob.id).to eq(1)
    end
  end


end
