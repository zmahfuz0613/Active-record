class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.string :name
      t.integer :grade
      t.integer :course_id

      t.timestamps
    end

    add_index :students, :course_id
  end
end
