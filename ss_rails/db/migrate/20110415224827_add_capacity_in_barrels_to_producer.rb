class AddCapacityInBarrelsToProducer < ActiveRecord::Migration
  def self.up
    add_column :producers, :capacity_in_barrels, :integer
  end

  def self.down
    remove_column :producers, :capacity_in_barrels
  end
end
