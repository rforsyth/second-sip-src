class AddRealNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :real_name, :string, :limit => 150
  end

  def self.down
    remove_column :users, :real_name
  end
end
