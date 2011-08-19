class SetNotNullForAllTheColumnsYouForgot < ActiveRecord::Migration
  def self.up
    change_column :friendships, :creator_id, :integer, :null => false
    change_column :friendships, :updater_id, :integer, :null => false
    change_column :friendships, :inviter_id, :integer, :null => false
    change_column :friendships, :invitee_id, :integer, :null => false
    change_column :friendships, :invitation, :text, :null => false
    change_column :friendships, :created_at, :datetime, :null => false
    change_column :friendships, :updated_at, :datetime, :null => false
    change_column :friendships, :status, :integer, :null => false
    
    change_column :looked, :lookup_id, :integer, :null => false
    change_column :looked, :lookable_id, :integer, :null => false
    change_column :looked, :lookable_type, :string, :limit => 100, :null => false
    
    change_column :lookups, :created_at, :datetime, :null => false
    change_column :lookups, :updated_at, :datetime, :null => false
    change_column :lookups, :owner_id, :integer, :null => false
    
    change_column :notes, :created_at, :datetime, :null => false
    change_column :notes, :updated_at, :datetime, :null => false
    
    change_column :producers, :created_at, :datetime, :null => false
    change_column :producers, :updated_at, :datetime, :null => false
    change_column :producers, :website_url, :string, :limit => 500
    
    change_column :products, :created_at, :datetime, :null => false
    change_column :products, :updated_at, :datetime, :null => false
    
    change_column :reference_looked, :reference_lookup_id, :integer, :null => false
    change_column :reference_looked, :reference_lookable_id, :integer, :null => false
    change_column :reference_looked, :reference_lookable_type, :string, :limit => 100, :null => false
    
    change_column :reference_lookups, :created_at, :datetime, :null => false
    change_column :reference_lookups, :updated_at, :datetime, :null => false
    
    change_column :reference_producers, :creator_id, :integer, :null => false
    change_column :reference_producers, :updater_id, :integer, :null => false
    change_column :reference_producers, :type, :string, :limit => 100, :null => false
    change_column :reference_producers, :website_url, :string, :limit => 500
    change_column :reference_producers, :name, :string, :limit => 150
    change_column :reference_producers, :canonical_name, :string, :limit => 150
    change_column :reference_producers, :created_at, :datetime, :null => false
    change_column :reference_producers, :updated_at, :datetime, :null => false
    
    change_column :reference_products, :creator_id, :integer, :null => false
    change_column :reference_products, :updater_id, :integer, :null => false
    change_column :reference_products, :type, :string, :limit => 100, :null => false
    change_column :reference_products, :reference_producer_id, :integer, :null => false
    change_column :reference_products, :name, :string, :limit => 150
    change_column :reference_products, :canonical_name, :string, :limit => 150
    change_column :reference_products, :created_at, :datetime, :null => false
    change_column :reference_products, :updated_at, :datetime, :null => false
    
    change_column :resources, :url, :string, :limit => 500
    change_column :resources, :created_at, :datetime, :null => false
    change_column :resources, :updated_at, :datetime, :null => false
    
    change_column :tagged, :tag_id, :integer, :null => false
    change_column :tagged, :taggable_id, :integer, :null => false
    change_column :tagged, :taggable_type, :string, :limit => 100, :null => false
    
    change_column :tags, :creator_id, :integer, :null => false
    change_column :tags, :updater_id, :integer, :null => false
    change_column :tags, :name, :string, :limit => 150, :null => false
    change_column :tags, :type, :string, :limit => 100, :null => false
    change_column :tags, :created_at, :datetime, :null => false
    change_column :tags, :updated_at, :datetime, :null => false
    
    change_column :tasters, :username, :string, :limit => 100, :null => false
    change_column :tasters, :canonical_username, :string, :limit => 100, :null => false
    change_column :tasters, :email, :string, :limit => 150, :null => false
    change_column :tasters, :crypted_password, :string, :limit => 500, :null => false
    change_column :tasters, :password_salt, :string, :limit => 500, :null => false
    change_column :tasters, :persistence_token, :string, :limit => 500, :null => false
    change_column :tasters, :greeting, :string, :limit => 1000
    change_column :tasters, :created_at, :datetime, :null => false
    change_column :tasters, :updated_at, :datetime, :null => false
  end

  def self.down
  end
end
