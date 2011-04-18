class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.integer :created_by,					:null => false
      t.integer :updated_by,					:null => false
      t.string :title,         				:limit   => 150, :null => false
      t.text :body
      t.text :wiki_text
      t.string :url
      t.integer :type,         				:null => false
      t.references :lookup,						:null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
