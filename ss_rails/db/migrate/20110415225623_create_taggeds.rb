class CreateTaggeds < ActiveRecord::Migration
  def self.up
    create_table :tagged do |t|
      t.integer :tag_id
      t.integer :taggable_id
      t.string :taggable_type
    end
  end

  def self.down
    drop_table :tagged
  end
end
