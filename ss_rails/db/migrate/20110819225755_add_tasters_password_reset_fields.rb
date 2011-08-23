class AddTastersPasswordResetFields < ActiveRecord::Migration
  def self.up
    add_column :tasters, :perishable_token, :string, :default => "", :null => false 
    add_index :tasters, :perishable_token  
    add_index :tasters, :email  
  end

  def self.down
    remove_column :tasters, :perishable_token  
    remove_column :tasters, :email
  end
end
