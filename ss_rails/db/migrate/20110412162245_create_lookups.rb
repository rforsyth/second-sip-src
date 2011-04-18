class CreateLookups < ActiveRecord::Migration
  def self.up
    create_table :lookups do |t|
      t.string :name,         				:limit   => 150, :null => false
      t.string :canonical_name,       :limit   => 150, :null => false
      t.text :description
      t.integer :lookup_type,      		:null => false
      t.string :entity_type,         	:limit   => 50, :null => false
      t.integer :parent_lookup_id
      t.string :full_name,         		:limit   => 500, :null => false
      t.string :canonical_full_name,  :limit   => 500, :null => false
      t.boolean :is_reference

      t.timestamps
    end
  end

  def self.down
    drop_table :lookups
  end
end
