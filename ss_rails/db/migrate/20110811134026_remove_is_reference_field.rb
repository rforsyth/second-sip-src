class RemoveIsReferenceField < ActiveRecord::Migration
  def self.up
    remove_column :lookups, :is_reference
    remove_column :producers, :is_reference
    remove_column :products, :is_reference
    remove_column :notes, :is_reference
  end

  def self.down
    add_column :lookups, :is_reference, :boolean
    add_column :producers, :is_reference, :boolean
    add_column :products, :is_reference, :boolean
    add_column :notes, :is_reference, :boolean
  end
end
