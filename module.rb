module Database

    def connect()
         return SQLite3::Database.new('db/db.db')
    end

    def user_info(name:)
        db = connect()
        return db.execute("SELECT * FROM users WHERE name=?",name)
    end

    def user_info_by_id(id:)
        db = connect()
        return db.execute("SELECT * FROM users WHERE id=?",id.to_i)
    end

    def register(username:, password:)
        db = connect()
        db.execute("INSERT INTO users(name,password) VALUES(?,?)", [username,password])
    end

    def search(name:)
        db = connect()
        db.execute("SELECT id,name FROM users WHERE name LIKE ?", ["%#{name}%"])
    end

    def private_chat(from:, to:)
        db = connect()
        db.execute("SELECT id,message FROM private_message WHERE `to` = ? AND `from` = ?", [to,from])
    end

end


