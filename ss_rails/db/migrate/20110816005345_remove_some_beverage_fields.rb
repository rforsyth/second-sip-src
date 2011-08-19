class RemoveSomeBeverageFields < ActiveRecord::Migration
  def self.up
    remove_column :producers, :cases_per_year
    remove_column :producers, :capacity_in_barrels
    remove_column :reference_producers, :cases_per_year
    remove_column :reference_producers, :capacity_in_barrels
    remove_column :products, :alcohol_by_volume
  end

  def self.down
    add_column :producers, :cases_per_year, :integer
    add_column :producers, :capacity_in_barrels, :integer
    add_column :reference_producers, :cases_per_year, :integer
    add_column :reference_producers, :capacity_in_barrels, :integer
    add_column :products, :alcohol_by_volume, :float
  end
end
