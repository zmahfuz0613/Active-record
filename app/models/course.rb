class Course < ApplicationRecord
  belongs_to :teacher
  has_many :students

  def grades
    students.pluck(:grade)
  end

  # finally! a random pair generator written in ruby!
  def generate_pairs
    students.shuffle.each_slice(2).to_a
  end
end
