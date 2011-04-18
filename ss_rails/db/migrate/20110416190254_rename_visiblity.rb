class RenameVisiblity < ActiveRecord::Migration
  def self.up
		rename_column :notes, :visiblity, :visibility
		rename_column :products, :visiblity, :visibility
		rename_column :producers, :visiblity, :visibility
  end

  def self.down
		rename_column :notes, :visibility, :visiblity
		rename_column :products, :visibility, :visiblity
		rename_column :producers, :visibility, :visiblity
  end
end
