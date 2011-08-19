class SetOccasionSize < ActiveRecord::Migration
  def self.up
    change_column :notes, :occasion, :string, :limit => 150
  end

  def self.down
  end
end
