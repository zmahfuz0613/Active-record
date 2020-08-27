class Student < ApplicationRecord
  belongs_to :course
  has_one :teacher, through: :course
  
end
