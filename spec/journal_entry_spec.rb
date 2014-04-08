require 'spec_helper'

module DMR

  describe 'Journal' do


    it 'Exist' do
      expect(DMR::JournalEntry).to be_a(Class)
    end

    it 'Can take in data' do
      journal = JournalEntry.new({user_id: 1, creation_date: Time.new(2014,4,7,9,30), title: "Thoughts", entry: "Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah ", entry_type: 'Thought Dump' })

      expect(journal.user_id).to eq(1)
      expect(journal.creation_date).to eq(Time.new(2014,4,7,9,30))
      expect(journal.title).to eq("Thoughts")
      expect(journal.entry).to eq("Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah ")
      expect(journal.entry_type).to eq("Thought Dump")

    end

  end

end
