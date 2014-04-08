require 'spec_helper'

module DMR
  describe 'CreateJournalEntry' do
    it "returns an error if the entry already exists" do
      @user1 = DMR.db.create_user({ password: "password",
                            full_name: "Bob Bobberson", email: "bob@bob.com",
                            birthdate: Time.new(1990, 1, 1),
                            phone: "512-791-4819" })
      @session = DMR.db.create_session(@user1.id)
      entry = DMR.db.create_journal_entry({ user_id: @user1.id,
                                      creation_date: Time.new(2013, 4,1),
                                      title: "Why I'm Awesome",
                                      entry: "I am awesome because I'm the best in the world. No one compares.
                                                  It's pretty fucking ridiculous, actually.",
                                                  entry_type: "thoughts" })
      result = CreateJournalEntry.run({ session_id: @session.id, user_id: @user1.id,
                                      creation_date: Time.new(2013, 4,1),
                                      title: "Why I'm Awesome",
                                      entry: "I am awesome because I'm the best in the world. No one compares.
                                                  It's pretty fucking ridiculous, actually.",
                                                  entry_type: "thoughts" })
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:date_already_filled)
    end

    it "creates a journal entry" do
      @user1 = DMR.db.create_user({ password: "password",
                            full_name: "Bob Bobberson", email: "bob@bob.com",
                            birthdate: Time.new(1990, 1, 1),
                            phone: "512-791-4819" })
      @session = DMR.db.create_session(@user1.id)
      result = CreateJournalEntry.run({ session_id: @session.id, user_id: @user1.id,
                                      creation_date: Time.new(2013, 4,1),
                                      title: "Why I'm Awesome",
                                      entry: "I am awesome because I'm the best in the world. No one compares.
                                                  It's pretty fucking ridiculous, actually.",
                                                  entry_type: "thoughts" })
      expect(result.success?).to eq(true)
      expect(DMR.db.get_journal_entry(@user1.id, Time.new(2013, 4,1)).id).to eq(result.entry.id)
    end

  end
end
