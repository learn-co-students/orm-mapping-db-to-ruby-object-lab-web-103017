require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    #binding.pry
    new_student = Student.new
    #exibinding.pry
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class

    all_students = DB[:conn].execute("select * from students")
    students = []
    all_students.map do |x|
      new_student = Student.new
      new_student.id = x[0]
      new_student.name = x[1]
      new_student.grade = x[2]
      students << new_student
    end
    students
  end

  def self.first_X_students_in_grade_10(limit)
    DB[:conn].execute("select * from students where grade=10 limit #{limit}")

  end

  def self.first_student_in_grade_10
    row = DB[:conn].execute("select * from students where grade=10 limit 1").flatten
    new_student = Student.new
    #binding.pry
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    #binding.pry
    row = DB[:conn].execute("select * from students where name='#{name}'").flatten
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all_students_in_grade_X(arg)
    DB[:conn].execute("select * from students where grade='#{arg}'")
  end


  def self.count_all_students_in_grade_9
    DB[:conn].execute("select * from students where grade='9'")
  end

  def self.students_below_12th_grade
    DB[:conn].execute("select * from students where grade<'12'")
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

#binding.pry
