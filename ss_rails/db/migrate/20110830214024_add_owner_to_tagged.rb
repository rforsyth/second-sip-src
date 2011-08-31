class AddOwnerToTagged < ActiveRecord::Migration
  def self.up
    add_column :tagged, :owner_id, :integer, :null => false
  end

  def self.down
    remove_column :tagged, :owner_id, :integer
  end
end
