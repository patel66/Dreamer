require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require_relative 'lib/dreamer.rb'

DMR.db_name = 'DMR_test.db'

set :bind, '0.0.0.0'

get '/welcome' do
  #@name = params[:name]
  erb :welcome
end

get '/sign_up' do
  erb :sign_up
end

get '/home_page' do
  erb :home_page
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
  result = DMR::SignUp.run({ email: @email, password: @password, birthdate: @birthdate,
                  full_name: @full_name, phone: @phone })
  if result.success?
    session[:dmr_sid] = result[:session_id]
    erb :home_page
  elsif result.error == :email_taken
    @error_message = "That email is already taken.  Please Try Again. "
    erb :sign_up_error
  end
end

post '/home_page' do
  erb :home_page

end

get '/journal' do
  erb :journal
end

get '/journal_entry' do
  erb :journal_entry
end

post 'journal_entry' do
  @title = params[:title]
  @entry = params[:entry]
end

get '/sign_in' do
  erb :sign_in
end

get '/get_journals' do
  erb :sign_in
end



post '/sign_in' do
  erb
end
