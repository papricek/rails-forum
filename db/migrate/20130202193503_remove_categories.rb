class RemoveCategories < ActiveRecord::Migration
  def change
    drop_table :categories
    remove_column :forums, :category_id
  end
end
