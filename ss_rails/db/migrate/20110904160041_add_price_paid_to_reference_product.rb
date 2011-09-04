class AddPricePaidToReferenceProduct < ActiveRecord::Migration
  def self.up
    add_column :reference_products, :price_paid, :float
  end

  def self.down
    remove_column :reference_products, :price_paid
  end
end
