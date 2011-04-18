class RemoveIsBannedFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :is_banned
  end

  def self.down
    add_column :users, :is_banned, :boolean
  end
end
