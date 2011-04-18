class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.integer :created_by, :null => false
      t.integer :updated_by, :null => false
      t.string :type, :null => false, :limit => 50
      t.integer :owner_id, :null => false
      t.integer :visiblity, :null => false
      t.boolean :is_reference
      t.integer :producer_id, :null => false
      t.string :name, :null => false, :limit => 150
      t.string :canonical_name, :null => false, :limit => 150
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
    drop_table :products
  end
end
