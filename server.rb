require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pry-debugger'
require_relative 'lib/dreamer.rb'

DMR.db_name = 'DMR_test.db'

enable :sessions

set :bind, '0.0.0.0'

get '/' do
  erb :welcome
end

get '/sign_up' do
  erb :sign_up
end

get '/home_page' do
  result = DMR::CheckSignIn.run(session[:dmr_sid])
  if result.success? == false
    redirect '/sign_in'
  else
    erb :home_page
  end
end

get '/sleep_profile' do
  erb :sleep_profile
end

get '/sleep_info' do
  erb :sleep_info
end

post '/sign_up' do
  email = params[:email]
  password = params[:password]
  full_name = params[:full_name]
  year = params[:birthdate].split('-')[0].to_i
  month = params[:birthdate].split('-')[1].to_i
  day = params[:birthdate].split('-')[2].to_i
  birthdate = Time.new(year, month, day)
  phone = params[:phone]
  result = DMR::SignUp.run({ email: email, password: password, birthdate: birthdate,
                  full_name: full_name, phone: phone })

  if result.success?
    session[:dmr_sid] = result[:session_id]
    redirect "/home_page"
  elsif result.error == :email_taken
    @error_message = "That email is already taken.  Please Try Again. "
    erb :sign_up_error
  end
end

post '/home_page' do
  # Check if user is signed in

  erb :home_page
end

get '/journal' do
  erb :journal
end

get '/journal_entry' do
  erb :journal_entry
end

post '/journal_entry' do
  @title = params[:title]
  @entry = params[:entry]
  result = DMR::CreateJournalEntry.run({ session_id: session[:dmr_sid],
                                          title: @title, entry: @entry,
                                          creation_date: Time.now,
                                          entity_type: "night" })
  if result.success?
    redirect '/get_journals'
  else
  end
end

post '/sleep_entry' do
  year = params[:date].split('-')[0].to_i
  month = params[:date].split('-')[1].to_i
  day = params[:date].split('-')[2].to_i
  date = Time.new(year, month, day)
  sleep_hour = params[:sleep_time].split('%3A')[0]
  sleep_minute = params[:sleep_time].split('%3A')[1]
  wake_hour = params[:wake_time].split('%3A')[0]
  wake_minute = params[:wake_time].split('%3A')[1]

  result = DMR::CreateSleepEntry.run({ session_id: session[:dmr_sid],
                                        sleep_time: Time.new(year, month, day, sleep_hour, sleep_minute),
                                        wake_time: Time.new(year, month, (day + 1), wake_hour, wake_minute) })

  if result.success?
    redirect '/home_page'
  else
    "Fuck"
  end

end


get '/sign_in' do
  erb :sign_in
end

get '/get_journals' do
  result = DMR::GetAllJournalEntries.run({ session_id: session[:dmr_sid] })
  binding.pry
  if result.success?
    @entries = result.entries
    erb :journal_index
  else
    redirect '/sign_in'
  end
end

get '/entries/:entry_id' do
  result = DMR::GetJournalEntryByID.run(params[:entry_id])
  @entry = result[:entry]
  @title = @entry.title
  @entry_body = @entry.entry

  erb :get_entries
end

post '/sign_in' do
  result = DMR::SignIn.run({ email: params[:email],
                            password: params[:password] })
  if result.success?
    session[:dmr_sid] = result[:session_id]
    erb :home_page
  elsif result.error == :email_not_found
    @error_message = "Email Not Found"
    erb :sign_in_error
  elsif result.error = :incorrect_password
    @error_message = "Password Incorrect"
    erb :sign_in_error
  end
end

get '/sign_out' do
  result = DMR::SignOut.run(session[:dmr_sid])
  erb :sign_out
end
