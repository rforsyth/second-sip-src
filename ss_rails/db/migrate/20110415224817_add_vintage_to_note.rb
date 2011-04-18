class AddVintageToNote < ActiveRecord::Migration
  def self.up
    add_column :notes, :vintage, :integer
  end

  def self.down
    remove_column :notes, :vintage
  end
end
