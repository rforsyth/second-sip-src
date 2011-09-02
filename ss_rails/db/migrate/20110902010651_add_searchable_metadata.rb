class AddSearchableMetadata < ActiveRecord::Migration
  def self.up
    add_column :products, :searchable_metadata, :string, :limit => 500
    add_column :notes, :searchable_metadata, :string, :limit => 500
    add_column :reference_products, :searchable_metadata, :string, :limit => 500
  end

  def self.down
    remove_column :products, :searchable_metadata
    remove_column :notes, :searchable_metadata
    remove_column :reference_products, :searchable_metadata
  end
end
