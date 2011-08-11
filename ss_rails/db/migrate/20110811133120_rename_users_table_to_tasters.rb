class RenameUsersTableToTasters < ActiveRecord::Migration
  def self.up
    rename_table :users, :tasters
  end

  def self.down
    rename_table :tasters, :users
  end
end
