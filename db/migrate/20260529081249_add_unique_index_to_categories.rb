class AddUniqueIndexToCategories < ActiveRecord::Migration[8.1]
  def change
    add_index :categories, %i[user_id name], unique: true
  end
end
