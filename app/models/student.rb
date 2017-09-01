class Student < ApplicationRecord
  belongs_to :course
  has_one :teacher, through: :course

  scope :top, -> { order(grade: :desc).first }

  def peers
    Student.where(course_id: course_id)
  end

  def say_hi
    "Hi, I am #{name} and I am #{age} years old"
  end
end
