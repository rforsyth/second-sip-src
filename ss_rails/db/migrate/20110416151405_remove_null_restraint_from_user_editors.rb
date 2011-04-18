class RemoveNullRestraintFromUserEditors < ActiveRecord::Migration
  def self.up
    remove_column :users, :creator_id
    add_column :users, :creator_id, :integer
    remove_column :users, :updater_id
    add_column :users, :updater_id, :integer
  end

  def self.down
    remove_column :users, :creator_id
    add_column :users, :creator_id, :integer, :null => false
    remove_column :users, :updater_id
    add_column :users, :updater_id, :integer, :null => false
  end
end
