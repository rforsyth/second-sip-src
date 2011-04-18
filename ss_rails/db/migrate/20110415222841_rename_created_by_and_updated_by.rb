class RenameCreatedByAndUpdatedBy < ActiveRecord::Migration
  def self.up
		rename_column :lookups, :created_by, :creator_id
		rename_column :lookups, :updated_by, :updater_id
		rename_column :notes, :created_by, :creator_id
		rename_column :notes, :updated_by, :updater_id
		rename_column :producers, :created_by, :creator_id
		rename_column :producers, :updated_by, :updater_id
		rename_column :products, :created_by, :creator_id
		rename_column :products, :updated_by, :updater_id
		rename_column :resources, :created_by, :creator_id
		rename_column :resources, :updated_by, :updater_id
		rename_column :users, :created_by, :creator_id
		rename_column :users, :updated_by, :updater_id
  end

  def self.down
		rename_column :lookups, :creator_id, :created_by
		rename_column :lookups, :updater_id, :updated_by
		rename_column :notes, :creator_id, :created_by
		rename_column :notes, :updater_id, :updated_by
		rename_column :producers, :creator_id, :created_by
		rename_column :producers, :updater_id, :updated_by
		rename_column :products, :creator_id, :created_by
		rename_column :products, :updater_id, :updated_by
		rename_column :resources, :creator_id, :created_by
		rename_column :resources, :updater_id, :updated_by
		rename_column :users, :creator_id, :created_by
		rename_column :users, :updater_id, :updated_by
  end
end
