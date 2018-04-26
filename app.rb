class App < Sinatra::Base

	require_relative 'module.rb'
	include Database
	enable :sessions



	get '/' do
		session[:user] = nil
		slim(:index, locals:{error:session[:error]})
	end

	get '/chat' do
		user = user_info_by_id(id:session[:user])
		slim(:chat, locals:{value:session[:search],result:session[:searchresult], user:user, id:nil})
	end

	get '/chat/:id' do
		id = params[:id].to_i
		p id
		p session[:user]
		chat_recieve = private_chat(from:session[:user], to:id)
		chat_to = private_chat(from:id, to:session[:user])
		index = []
		library = []
		chat_recieve.each do |message|
			hash = {"value"=>message, "list" => "recieve"}
			index.push(message[0])
			library.push(hash)
		end
		chat_to.each do |message|
			index.push(message[0])
			hash = {"value"=>message, "list" => "to"}
			library.push(hash)
		end
		index.sort!
		user = user_info_by_id(id:session[:user])
		slim(:chat, locals:{value:session[:search],result:session[:searchresult], user:user, id:id})
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

	post '/search' do
		name = params["search"]
		list = search(name:name)
		session[:searchresult] = list
		session[:search] = name
		redirect('/chat')
	end
end            