class CreateReferenceLookups < ActiveRecord::Migration
  def self.up
    create_table :reference_lookups do |t|
      t.string   "name",                :limit => 150, :null => false
      t.string   "canonical_name",      :limit => 150, :null => false
      t.text     "description"
      t.integer  "lookup_type",                        :null => false
      t.string   "entity_type",         :limit => 50,  :null => false
      t.integer  "parent_reference_lookup_id"
      t.string   "full_name",           :limit => 500, :null => false
      t.string   "canonical_full_name", :limit => 500, :null => false
      t.integer  "creator_id",                         :null => false
      t.integer  "updater_id",                         :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :reference_lookups
  end
end
