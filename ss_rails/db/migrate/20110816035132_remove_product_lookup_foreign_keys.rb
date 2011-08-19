class RemoveProductLookupForeignKeys < ActiveRecord::Migration
  def self.up
    remove_column :products, :region_lookup_id
    remove_column :products, :style_lookup_id
    remove_column :reference_products, :region_lookup_id
    remove_column :reference_products, :style_lookup_id
  end

  def self.down
    add_column :products, :region_lookup_id, :integer
    add_column :products, :style_lookup_id, :integer
    add_column :reference_products, :region_lookup_id, :integer
    add_column :reference_products, :style_lookup_id, :integer
  end
end
