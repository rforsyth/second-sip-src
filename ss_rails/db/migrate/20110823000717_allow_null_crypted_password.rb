class AllowNullCryptedPassword < ActiveRecord::Migration
  def self.up
    change_column :tasters, :crypted_password, :string, :null => true, :limit => 500
    change_column :tasters, :password_salt, :string, :null => true, :limit => 500
  end
 
  def self.down
    change_column :tasters, :crypted_password, :string, :null => false
    change_column :tasters, :password_salt, :string, :null => false
  end
end
