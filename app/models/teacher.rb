class Teacher < ApplicationRecord
  include Studentsable

  has_many :courses
  has_many :students, through: :courses

  validates_presence_of :name


  def say_hi
    "Hi, I am #{name} and I teach #{courses.count} courses"
  end
end
