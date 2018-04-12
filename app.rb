class App < Sinatra::Base

	require_relative 'module.rb'
	include Database
	enable :sessions



	get '/' do
		slim(:index, locals:{error:session[:error]})
	end

	get '/chat' do
		slim(:chat)
	end

	post '/register' do
		username = params["name"]
		password = params["password"]
		confirm = params["confirm"]
		if password != confirm
			session[:error] = "Passwords does not match"
			redirect('/')
		end
		password_digest = BCrypt::Password.create(password)
		begin
			register(username:username, password:password_digest)
		rescue SQLite3::ConstraintException
			session[:error] = "Username already exists"
			redirect('/')
		end
		redirect('/')
	end

	post '/login' do
		username = params["name"]
		password = params["password"]
		info = user_info(name:username)
		if info == []
			session[:error] = "Invalid credentials"
			redirect('/')
		end
		password_digest = info[0][2]
		if BCrypt::Password.new(password_digest) == password
			session[:user] = info[0][0]
			redirect('/chat')
		else
			session[:error] = "Invalid credentials"
			redirect('/')
		end
	end
end            