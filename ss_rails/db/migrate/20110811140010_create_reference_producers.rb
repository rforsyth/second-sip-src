class CreateReferenceProducers < ActiveRecord::Migration
  def self.up
    create_table :reference_producers do |t|
      t.integer :creator_id
      t.integer :updater_id
      t.string :type
      t.string :website_url
      t.string :name
      t.string :canonical_name
      t.text :description
      t.integer :cases_per_year
      t.integer :capacity_in_barrels

      t.timestamps
    end
  end

  def self.down
    drop_table :reference_producers
  end
end
