require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
#require 'pry-debugger'
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
  result = DMR::CheckSignIn(session[:dmr_sid])
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
end

get '/sign_in' do
  erb :sign_in
end

get '/get_journals' do

  erb :sign_in
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
