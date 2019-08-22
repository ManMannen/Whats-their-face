# module AppModule

    def database()
        db = SQLite3::Database.new("db/db.db")
        db.results_as_hash = true
        db
    end
    
    def login(params)
        first_name = params["full_name"].split[0]
        last_name = params["full_name"].split[1]
        db = database()
        result = db.execute("SELECT * FROM teachers WHERE first_name = ?", params["first_name"])
        if result.length > 0
            if BCrypt::Password.new(result[0]["password"]) == params["password"] && result[0]["first_name"] == params["first_name"]
                {
                student_id: result[0]["student_id"],
                first_name: params["first_name"]
                }
            else
                flash[:wrong_password] = "Incorrect Password"
            end
        end
    end

    def create(params)
        db = database()
        first_name = params["firstname"] 
        last_name = params["lastname"]
        password = params["password"]
        password_hash = BCrypt::Password.create(password)
        db.execute("INSERT INTO teachers (first_name, last_name, password) VALUES (?,?,?)", first_name, last_name, password_hash)
    end

    def change_username(params, student_id) 
        db = database()
        db.execute("UPDATE users SET username = ? WHERE student_id = ?", params['change_username'], student_id)
    end
    
    def change_password(params, student_id) 
        db = database()
        db.execute("UPDATE users SET password = ? WHERE student_id = ?", params['change_password'], student_id)
    end