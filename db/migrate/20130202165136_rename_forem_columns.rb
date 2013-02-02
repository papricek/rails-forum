class RenameForemColumns < ActiveRecord::Migration
  def change
    rename_column :users, :forem_admin, :admin
    rename_column :users, :forem_state, :state
    rename_column :users, :forem_auto_subscribe, :auto_subscribe
  end
end
