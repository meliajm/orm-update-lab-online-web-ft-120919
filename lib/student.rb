require_relative "../config/environment.rb"
require 'pry'
class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade 
    @id = id
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    # sql = <<-SQL
    #   INSERT INTO students (name, grade)
    #   VALUES (?, ?)
    # SQL
    # DB[:conn].execute(sql, self.name, self.grade)
    # sql = <<-SQL
    #   INSERT INTO students (name, grade)
    #   VALUES (?, ?)
    # SQL

    # DB[:conn].execute(sql, self.name, self.grade)

    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, album)
    student = self.new(name, album)
    student.save
    student
  end 

  def self.new_from_db(row)
    # binding.pry
    student = self.new(row[1], row[2], row[0])
    # student
  end

  # def self.find_by_name(name)
  #   sql = <<-SQL
  #     SELECT * FROM students
  #     WHERE name = ?
  #   SQL
  #   result = DB[:conn].execute(sql, self.name)[0]
  #   self.new(result[0], result[1], result[2])
  # end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    student = self.new(result[1], result[2], result[0])
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
