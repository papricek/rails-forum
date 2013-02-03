class AddSortToForums < ActiveRecord::Migration
  def change
    add_column :forums, :sort, :integer, default: 0
  end
end
