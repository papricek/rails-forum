class DropStaleTables < ActiveRecord::Migration
  def change
    drop_table :groups
    drop_table :memberships
    drop_table :moderator_groups
  end
end
