class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.integer :creator_id
      t.integer :updater_id
      t.string :name
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
