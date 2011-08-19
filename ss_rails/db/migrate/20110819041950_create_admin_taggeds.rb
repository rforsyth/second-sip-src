class CreateAdminTaggeds < ActiveRecord::Migration
  def self.up
    create_table :admin_tagged do |t|
      t.integer :admin_tag_id,                   :null => false
      t.integer :admin_taggable_id,                   :null => false
      t.string :admin_taggable_type, :limit => 100,   :null => false
    end
  end

  def self.down
    drop_table :admin_tagged
  end
end
