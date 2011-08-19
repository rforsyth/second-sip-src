class RemoveReferenceProductPricePaid < ActiveRecord::Migration
  def self.up
    remove_column :reference_products, :price_paid
  end

  def self.down
    add_column :reference_products, :price_paid
  end
end
