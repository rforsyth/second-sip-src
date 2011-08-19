class RenameReferenceLookedsTable < ActiveRecord::Migration
  def self.up
    rename_table :reference_lookeds, :reference_looked
  end

  def self.down
    rename_table :reference_looked, :reference_lookeds
  end
end
