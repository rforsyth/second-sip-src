class AddOwnerToLooked < ActiveRecord::Migration
  def self.up
    add_column :looked, :owner_id, :integer, :null => false
  end

  def self.down
    remove_column :looked, :owner_id, :integer
  end
end
