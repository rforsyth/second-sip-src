class AddOwnerToLookups < ActiveRecord::Migration
  def self.up
    add_column :lookups, :owner_id, :integer
  end

  def self.down
    remove_column :lookups, :owner_id
  end
end
