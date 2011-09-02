class AddEntityTypeToTag < ActiveRecord::Migration
  def self.up
    add_column :tags, :entity_type, :string, :limit => 50, :null => false
    add_column :admin_tags, :entity_type, :string, :limit => 50, :null => false
  end

  def self.down
    remove_column :tags, :entity_type
    remove_column :admin_tags, :entity_type
  end
end
