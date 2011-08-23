class RenameTastersVerifiedToActive < ActiveRecord::Migration
  def self.up
		rename_column :tasters, :verified, :active
  end

  def self.down
		rename_column :tasters, :active, :verified
  end
end
