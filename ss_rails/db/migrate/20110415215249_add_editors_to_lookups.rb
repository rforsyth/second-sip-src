class AddEditorsToLookups < ActiveRecord::Migration
  def self.up
    add_column :lookups, :created_by, :integer, :null => false
    add_column :lookups, :updated_by, :integer, :null => false
  end

  def self.down
    remove_column :lookups, :updated_by
    remove_column :lookups, :created_by
  end
end
