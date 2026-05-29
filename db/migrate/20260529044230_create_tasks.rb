class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: true, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.date :due_date
      t.integer :priority, default: 1, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
