class AddAgeToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :age, :integer
  end
end
