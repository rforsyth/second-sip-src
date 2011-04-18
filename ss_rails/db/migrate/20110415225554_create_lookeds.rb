class CreateLookeds < ActiveRecord::Migration
  def self.up
    create_table :looked do |t|
      t.integer :lookup_id
      t.integer :lookable_id
      t.string :lookable_type
    end
  end

  def self.down
    drop_table :looked
  end
end
