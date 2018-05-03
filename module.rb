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
        db.execute("SELECT id, `from`,message FROM private_message WHERE `to` = ? AND `from` = ? OR `to` = ? AND `from` = ?", [to,from,from,to])
    end

    def room_chat(id:)
        db = connect()
        db.execute("SELECT id, user_id, content FROM room_message WHERE room_id IN (SELECT id FROM room WHERE id=?) ", id)
    end

    def authorize(user_id:, room_id:)
        db = connect()
        confirm = db.execute("SELECT * FROM member WHERE room_id=? AND user_id=?", [room_id, user_id])
        if confirm.length > 0
            return true
        else
            return false
        end
    end

    def get_name(id:)
        db = connect()
        db.execute("SELECT name FROM users WHERE id=?", id)[0][0]
    end

    def write(from:,to:,content:)
        db = connect()
        db.execute("INSERT INTO private_message(`to`,`from`,message) VALUES(?,?,?)", [to,from,content])
    end
end


