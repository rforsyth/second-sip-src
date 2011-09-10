class SetProducerAndProductNameToNotNull < ActiveRecord::Migration
  def self.up
    change_column :reference_products, :reference_producer_name, :string, :limit => 150, :null => false
    change_column :reference_products, :reference_producer_canonical_name, :string, :limit => 150, :null => false
    change_column :products, :producer_name, :string, :limit => 150, :null => false
    change_column :products, :producer_canonical_name, :string, :limit => 150, :null => false
    change_column :notes, :producer_name, :string, :limit => 150, :null => false
    change_column :notes, :producer_canonical_name, :string, :limit => 150, :null => false
    change_column :notes, :product_name, :string, :limit => 150, :null => false
    change_column :notes, :product_canonical_name, :string, :limit => 150, :null => false        
  end

  def self.down
  end
end

