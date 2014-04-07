require 'spec_helper'

module DMR
  describe Session do
    it "is initialized with an id and a user_id" do
      session = Session.new(1,5)
      expect(session.user_id).to eq(5)
      expect(session.id).to eq(1)
    end
  end
end
