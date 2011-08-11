class RemoveReferenceFieldsFromLookups < ActiveRecord::Migration
  def self.up
    remove_column :lookups, :parent_lookup_id
    remove_column :lookups, :full_name
    remove_column :lookups, :canonical_full_name
  end

  def self.down
    add_column :lookups, :parent_lookup_id, :integer
    add_column :lookups, :full_name, :string
    add_column :lookups, :canonical_full_name, :string
  end
end
