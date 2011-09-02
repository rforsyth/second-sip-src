class RemoveOccasionFromNote < ActiveRecord::Migration
  def self.up
    remove_column :notes, :occasion
  end

  def self.down
    add_column :notes, :occasion, :string
  end
end
