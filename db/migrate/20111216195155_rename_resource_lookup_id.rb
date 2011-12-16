class RenameResourceLookupId < ActiveRecord::Migration
  def self.up
    rename_column :resources, :lookup_id, :reference_lookup_id
  end

  def self.down
  end
end
