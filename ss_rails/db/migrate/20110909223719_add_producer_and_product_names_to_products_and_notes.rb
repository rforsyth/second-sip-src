class AddProducerAndProductNamesToProductsAndNotes < ActiveRecord::Migration
  def self.up
    add_column :reference_products, :reference_producer_name, :string, :limit => 150
    add_column :reference_products, :reference_producer_canonical_name, :string, :limit => 150
    add_column :products, :producer_name, :string, :limit => 150
    add_column :products, :producer_canonical_name, :string, :limit => 150
    add_column :notes, :producer_name, :string, :limit => 150
    add_column :notes, :producer_canonical_name, :string, :limit => 150
    add_column :notes, :product_name, :string, :limit => 150
    add_column :notes, :product_canonical_name, :string, :limit => 150
  end

  def self.down
  end
end
