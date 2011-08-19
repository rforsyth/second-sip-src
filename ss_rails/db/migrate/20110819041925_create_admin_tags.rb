class CreateAdminTags < ActiveRecord::Migration
  def self.up
    create_table :admin_tags do |t|
      t.integer :creator_id,                   :null => false
      t.integer :updater_id,                   :null => false
      t.string :name,         :limit => 150,   :null => false
      t.timestamps                   :null => false
    end
  end

  def self.down
    drop_table :admin_tags
  end
end
