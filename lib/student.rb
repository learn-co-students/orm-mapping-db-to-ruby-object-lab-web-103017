require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_row = Student.new
    new_row.id = row[0]
    new_row.name = row[1]
    new_row.grade = row[2]
    new_row
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL
    #database above
    DB[:conn].execute(sql).collect { |student| Student.new_from_db(student)} #to ruby object, DB[:conn] . connection configured on run.rb set to new db file on db folder
  end #Student class can be called 'self'
  #.new_from_db creates a row that is a new instance of the Student class.

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL
    # binding.pry
    self.new_from_db(DB[:conn].execute(sql, name)[0])
    #name refering to my name attribute in class method, which is a string
    #name in sql is referring to the column name in database, ? mark is a paramaetr
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT name
      FROM students
      WHERE grade = 9
    SQL
    DB[:conn].execute(sql)[0]
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT name
      FROM students
      WHERE grade < 12
    SQL
    DB[:conn].execute(sql)[0]
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
    DB[:conn].execute(sql).collect {|student| self.new_from_db(student)}
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT name
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL
      # binding.pry
    DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    # sql = <<-SQL
    #   SELECT *
    #   FROM students
    #   WHERE grade = 10
    #   LIMIT 1
    # SQL
    self.new_from_db(DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1;")[0])
  end

  def self.all_students_in_grade_X(x)
    # sql = <<-SQL
    #   SELECT *
    #   FROM students
    #   WHERE grade = ?
    # SQL
      # binding.pry
    DB[:conn].execute("SELECT * FROM students WHERE grade = ?", x)[0]
  end
#----------------------------------------------------------------------------------
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
