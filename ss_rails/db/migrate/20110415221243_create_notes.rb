class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :created_by, :null => false
      t.integer :updated_by, :null => false
      t.string :type, :null => false, :limit => 50
      t.integer :owner_id, :null => false
      t.integer :visiblity, :null => false
      t.boolean :is_reference
      t.integer :product_id, :null => false
      t.text :description_overall
      t.string :description_appearance, :limit => 500
      t.string :description_aroma, :limit => 500
      t.string :description_flavor, :limit => 500
      t.string :description_mouthfeel, :limit => 500
      t.datetime :tasted_at, :null => false
      t.integer :score_type
      t.float :score
      t.integer :buy_when
      t.string :occasion

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
