class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    student_rows = DB[:conn].execute("SELECT * FROM students")
    student_rows.collect{|row| Student.new_from_db(row)}
  end

  def self.count_all_students_in_grade_9
    student_rows = DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
    student_rows.collect{|row| Student.new_from_db(row)}
  end

  def self.students_below_12th_grade
    student_rows = DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
    student_rows.collect{|row| Student.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(x)
    student_rows = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", x)
    student_rows.collect{|row| Student.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    student_rows = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1")
    student_rows.collect{|row| Student.new_from_db(row)}.first
  end

  def self.all_students_in_grade_X(x)
    student_rows = DB[:conn].execute("SELECT * FROM students WHERE grade = ?", x)
    student_rows.collect{|row| Student.new_from_db(row)}
  end

  def self.find_by_name(name)
    student_row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).flatten
    Student.new_from_db(student_row)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
