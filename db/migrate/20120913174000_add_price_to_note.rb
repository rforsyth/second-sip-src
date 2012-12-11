class AddPriceToNote < ActiveRecord::Migration
  def self.up
    add_column :notes, :price, :float
    add_column :notes, :price_paid, :float
    add_column :notes, :price_type, :integer
  end

  def self.down
  end
end
