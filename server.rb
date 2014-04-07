require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pry'

set :bind, '0.0.0.0'

get '/welcome' do
  #@name = params[:name]
  erb :welcome
end

get '/sign_up' do
  erb :sign_up
end

post '/sign_up' do
  @email = params[:email]
  @password = params[:password]
  @full_name = params[:full_name]
  @birthdate = Time.at(params[:birthdate])
  @phone = params[:phone]
  result = DMR.SignUp.run({ email: @email, password: @password, birthdate: @birthdate,
                  full_name: @full_name, phone: @phone })
  if result.success?
    erb :sign_up_success
  elsif result.error == :email_taken
    @error_message = "That email is already taken.  Please Try Again. "
    erb :sign_up_error
  end
end



end

get '/sign_in' do
  erb :sign_in
end
