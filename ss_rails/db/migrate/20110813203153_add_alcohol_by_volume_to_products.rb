class AddAlcoholByVolumeToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :alcohol_by_volume, :float
  end

  def self.down
    remove_column :products, :alcohol_by_volume
  end
end
