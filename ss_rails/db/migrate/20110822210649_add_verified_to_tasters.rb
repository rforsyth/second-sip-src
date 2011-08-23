class AddVerifiedToTasters < ActiveRecord::Migration
  def self.up
    add_column :tasters, :verified, :boolean, :default => false
  end

  def self.down
    remove_column :tasters, :verified
  end
end
