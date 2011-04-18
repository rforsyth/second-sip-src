class AddEditorsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :created_by, :integer, :null => false
    add_column :users, :updated_by, :integer, :null => false
  end

  def self.down
    remove_column :users, :updated_by
    remove_column :users, :created_by
  end
end
