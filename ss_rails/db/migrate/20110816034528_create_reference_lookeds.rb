class CreateReferenceLookeds < ActiveRecord::Migration
  def self.up
    create_table :reference_lookeds do |t|
      t.integer :reference_lookup_id
      t.integer :reference_lookable_id
      t.string :reference_lookable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :reference_lookeds
  end
end
