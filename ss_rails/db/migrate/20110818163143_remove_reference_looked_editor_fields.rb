class RemoveReferenceLookedEditorFields < ActiveRecord::Migration
  def self.up
    remove_column :reference_looked, :created_at
    remove_column :reference_looked, :updated_at
  end

  def self.down
    add_column :reference_looked, :created_at, :integer
    add_column :reference_looked, :updated_at, :integer
  end
end
