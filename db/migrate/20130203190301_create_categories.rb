class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :slug
      t.timestamps
    end

    add_column :forums, :category_id, :integer
  end
end
