def import()
    Dir.glob("public/img/import/*.jpg") do |img|
        split_info = img.split(" ") #Splittar upp informationen från bilden
        klass = split_info[0][-2..-1]
        last_name = split_info[2][0..-4]
        db = database()
        db.execute(
        "INSERT INTO
        students
        (class, first_name, last_name)
        Values (?,?,?)",
        klass, split_info[1], last_name
        ) #Skickar in informationen från bild till Server
        result = db.execute("
        SELECT student_id
        FROM 
        students
        WHERE 
        student_id = (SELECT MAX(student_id) 
        FROM
        students)")
        img_name = File.rename(img, "#{result[0]["student_id"]}" + ".jpg")
        if File.exist?("public/img/import")
            FileUtils.mv("public/img/import/#{img_name}", "public/img/class/#{klass")
        else
            "The file couldn't be moved"
        end
        return result, img_name # Byter namn till senaste student_id
    end
end
