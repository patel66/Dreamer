require 'spec_helper'

module DMR
  describe 'GetJournalEntry' do
    it "returns an error if the user is not found" do
      result = GetJournalEntry.run({session_id: 9999, date: Time.new(2014, 4,3) })
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:user_not_found)
    end

    it "returns an error if no entries are found" do
      @bob = DMR.db.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
      @session = DMR.db.create_session(@bob.id)
      result = GetJournalEntry.run({ session_id: @session.id, date: Time.new(2015, 4, 25) })
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:no_entries_found)
    end


    it "returns a list of all Journal Entries" do
      bob = DMR.db.create_user({ password: "password",
                          full_name: "Bob Bobberson", email: "bob@bob.com",
                          birthdate: Time.new(1990, 1, 1),
                          phone: "512-791-4819" })
      session = DMR.db.create_session(bob.id)
      entry = DMR.db.create_journal_entry({ user_id: bob.id,
                                    creation_date: Time.new(2013, 4,1),
                                    title: "Why I'm Awesome",
                                    entry: "I am awesome because I'm the best in the world. No one compares.
                                                It's pretty fucking ridiculous, actually.",
                                                entry_type: "thoughts" })
      entry = DMR.db.create_journal_entry({ user_id: bob.id,
                                    creation_date: Time.new(2013, 4,2),
                                    title: "Why I'm STILL Awesome",
                                    entry: "I am awesome because I'm the best in the world. No one compares.
                                                It's pretty fucking ridiculous, actually.",
                                                entry_type: "thoughts" })
      result = GetJournalEntry.run({ session_id: session.id, date: Time.new(2013, 4,2) })
      expect(result.success?).to eq(true)
      expect(result.entry.title).to eq("Why I'm STILL Awesome")
    end
  end
end
