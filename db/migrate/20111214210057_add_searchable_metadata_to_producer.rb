class AddSearchableMetadataToProducer < ActiveRecord::Migration
  def self.up
    add_column :producers, :searchable_metadata, :string, :limit => 500
    add_column :reference_producers, :searchable_metadata, :string, :limit => 500
  end

  def self.down
  end
end
