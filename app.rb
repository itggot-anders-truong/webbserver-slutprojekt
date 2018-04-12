class App < Sinatra::Base

	require_relative 'module.rb'
	include Database
	enable :sessions
	
	get '/' do
		slim(:index)
	end

	post '/register' do
		username = params["name"]
		password = params["password"]
		confirm = params["confirm"]
		return "Success!"
	end

end           
