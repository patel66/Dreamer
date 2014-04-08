require 'spec_helper'
require 'pry-debugger'

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

    it "can create a sleep_entry and retrieve it from the db" do

      entry1 = @db1.create_sleep_entry({ user_id: 1, sleep_time: Time.new(2014, 4,13,20),
                                      wake_time: Time.new(2014, 4,13,7,30) })
      expect(@db1.get_sleep_entry(entry1.id).id).to eq(entry1.id)
    end

    before do
      @entry1 = @db1.create_sleep_entry({ user_id: @user1.id, sleep_time: Time.new(2014, 4,13,20),
                       wake_time: Time.new(2014, 4,14,7,30) })
      @entry2 = @db1.create_sleep_entry({ user_id: @user1.id, sleep_time: Time.new(2014, 4,14,20),
                       wake_time: Time.new(2014, 4,15,7,30) })
      @entry3 = @db1.create_sleep_entry({ user_id: @user1.id, sleep_time: Time.new(2014, 4,15,20),
                       wake_time: Time.new(2014, 4,16,7,30) })
      @entry4 = @db1.create_sleep_entry({ user_id: 99, sleep_time: Time.new(2014, 4,13,20),
                       wake_time: Time.new(2014, 4,14,7,30) })
      @entry5 = @db1.create_sleep_entry({ user_id: 99, sleep_time: Time.new(2014, 4,14,20),
                       wake_time: Time.new(2014, 4,15,7,30) })
    end

    it "can return a list of all sleep entries for a user" do
      entries_list = @db1.get_sleep_entries_by_user(@user1.id)
      expect(entries_list.size).to eq(3)
      expect(entries_list.first.sleep_time).to eq(Time.new(2014, 4,13,20))
      expect(entries_list.last.wake_time).to eq(Time.new(2014, 4,16,7,30))
    end

    it "can return a user by their email" do
      user = @db1.get_user_by_email(@user1.email)
      expect(user.id).to eq(@user1.id)
      expect(user.email).to eq(@user1.email)
    end

    it "can return a specific sleep_entry by user_id, date" do
      entry = @db1.get_sleep_entry_by_user_and_date(@user1.id, Time.new(2014,4,15))
      expect(entry.sleep_time.day).to eq(15)
    end

    it "can return a week's worth of sleep entries by user_id, start_date" do

      entry4 = @db1.create_sleep_entry({ user_id: @user1.id, sleep_time: Time.new(2014, 4,16,20),
                       wake_time: Time.new(2014, 4,17,7,30) })
      entry5 = @db1.create_sleep_entry({ user_id: @user1.id, sleep_time: Time.new(2014, 4,17,20),
                       wake_time: Time.new(2014, 4,18,7,30) })
      entry6 = @db1.create_sleep_entry({ user_id: @user1.id, sleep_time: Time.new(2014, 4,18,20),
                       wake_time: Time.new(2014, 4,19,7,30) })
      entry7 = @db1.create_sleep_entry({ user_id: @user1.id, sleep_time: Time.new(2014, 4,19,20),
                       wake_time: Time.new(2014, 4,20,7,30) })

      week2_array = @db1.get_sleep_week(@user1.id, Time.new(2014,4,13))
      week1_array = @db1.get_sleep_week(@user1.id, Time.new(2014,4,16))
      expect(week2_array.size).to eq(7)
      expect(week1_array.size).to eq(4)
    end

    it "can return a month's worth of sleep entries by user_id, start_date" do


      current_sleep_time = Time.new(2010, 4,13,22)
      current_wake_time = Time.new(2010, 4,14,6)
      entries = []

      30.times do
        new_entry = @db1.create_sleep_entry({ user_id: @user1.id, sleep_time: current_sleep_time,
                       wake_time: current_wake_time })
        entries << new_entry
        current_wake_time += (24*60*60)
        current_sleep_time += (24*60*60)
      end

      month2_array = @db1.get_sleep_month(@user1.id, Time.new(2010,4,13))
      month1_array = @db1.get_sleep_month(@user1.id, Time.new(2010,4,28))
      expect(month2_array.size).to eq(30)
      expect(month1_array.size).to eq(15)
    end


    it "can create a journal entry" do
      entry = @db1.create_journal_entry({ user_id: @user1.id,
                                    creation_date: Time.now,
                                    title: "Why I'm Awesome",
                                    entry: "I am awesome because I'm the best in the world. No one compares.
                                                It's pretty fucking ridiculous, actually.",
                                                entry_type: "thoughts" })
      expect(entry.title).to eq("Why I'm Awesome")
      expect(entry.id).to be_a(Fixnum)
    end


    it "can return a list of all journal entries for a user" do
      entry = @db1.create_journal_entry({ user_id: @user1.id,
                                    creation_date: Time.new(2013, 4,1),
                                    title: "Why I'm Awesome",
                                    entry: "I am awesome because I'm the best in the world. No one compares.
                                                It's pretty fucking ridiculous, actually.",
                                                entry_type: "thoughts" })
      entry = @db1.create_journal_entry({ user_id: @user1.id,
                                    creation_date: Time.new(2013, 4,2),
                                    title: "Why I'm STILL Awesome",
                                    entry: "I am awesome because I'm the best in the world. No one compares.
                                                It's pretty fucking ridiculous, actually.",
                                                entry_type: "thoughts" })
      entries = @db1.get_journal_entries_for_user(@user1.id)
      expect(entries.size).to eq(2)
      expect(entries[0].title).to eq("Why I'm Awesome")
    end

    it "can retrieve a journal_entry" do
      entry = @db1.create_journal_entry({ user_id: @user1.id,
                                    creation_date: Time.new(2013, 4,1),
                                    title: "Why I'm Awesome",
                                    entry: "I am awesome because I'm the best in the world. No one compares.
                                                It's pretty fucking ridiculous, actually.",
                                                entry_type: "thoughts" })
      expect(@db1.get_journal_entry(@user1.id, Time.new(2013, 4, 1)).title).to eq("Why I'm Awesome")

    end


  end
end
