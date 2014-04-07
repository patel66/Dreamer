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

get '/sign_in' do
  erb :sign_in
end
