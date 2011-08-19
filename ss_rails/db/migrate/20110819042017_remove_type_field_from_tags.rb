class RemoveTypeFieldFromTags < ActiveRecord::Migration
  def self.up
    remove_column :tags, :type
  end

  def self.down
    add_column :tags, :type, :string
  end
end
