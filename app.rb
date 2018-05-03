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
		slim(:chat, locals:{value:session[:search],result:session[:searchresult], user:user, id:nil, message:[[]], names:[]})
	end

	get '/chat/:id' do
		id = params[:id].to_i
		message = private_chat(from:session[:user], to:id)
		user = user_info_by_id(id:session[:user])
		names = []
		message.each do |i|
			names.push(get_name(id:i[1]))
		end
		p names
		p message
		slim(:chat, locals:{value:session[:search],result:session[:searchresult], user:user, id:id, message:message, names:names,user_id:session[:user]})
	end

	get '/chat/room/:id' do
		id = params[:id].to_i
		message = room_chat(id:id)
		user = user_info_by_id(id:session[:user])
		p message
		if authorize(user_id:session[:user], room_id:id) == true
			slim(:chat, locals:{value:session[:search],result:session[:searchresult], user:user, id:id, message:message})
		else
			redirect('./chat')
		end
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

	post "/write/:from/:to" do
		from = params[:from]
		to = params[:to]
		content = params['content']
		write(from:from,to:to,content:content)
		redirect("/chat/#{to}")
	end
end            