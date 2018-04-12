module Database
    def connect()
        return SQLite3::Database.new('db/db.db')
    end

    def user_info(name:)
        db = connect()
        return db.execute("SELECT * FROM users WHERE name=?",name)
    end

    def register(username:, password:)
        db = connect()
        db.execute("INSERT INTO users(name,password) VALUES(?,?)", [username,password])
    end



end