class CreateReferenceProducts < ActiveRecord::Migration
  def self.up
    create_table :reference_products do |t|
      t.integer :creator_id
      t.integer :updater_id
      t.string :type
      t.integer :reference_producer_id
      t.string :name
      t.string :canonical_name
      t.text :description
      t.float :price
      t.float :price_paid
      t.integer :price_type
      t.integer :region_lookup_id
      t.integer :style_lookup_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reference_products
  end
end
