class RenameResourceType < ActiveRecord::Migration
  def self.up
		rename_column :resources, :type, :resource_type
  end

  def self.down
		rename_column :notes, :resource_type, :type
  end
end
