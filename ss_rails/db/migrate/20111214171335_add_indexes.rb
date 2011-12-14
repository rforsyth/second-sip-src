class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :admin_tagged, :admin_taggable_id
    add_index :admin_tagged, :admin_taggable_type

    add_index :tagged, :taggable_id
    add_index :tagged, :taggable_type
    add_index :tagged, :owner_id

    add_index :tags, :name
    add_index :tags, :entity_type

    add_index :admin_tags, :name
    add_index :admin_tags, :entity_type

    add_index :friendships, :inviter_id
    add_index :friendships, :invitee_id
    add_index :friendships, :status

    add_index :looked, :lookable_id
    add_index :looked, :lookable_type
    add_index :looked, :owner_id
  
    add_index :reference_looked, :reference_lookable_id
    add_index :reference_looked, :reference_lookable_type

    add_index :lookups, :canonical_name
    add_index :lookups, :lookup_type
    add_index :lookups, :entity_type
    add_index :lookups, :owner_id

    add_index :reference_lookups, :canonical_name
    add_index :reference_lookups, :lookup_type
    add_index :reference_lookups, :entity_type
    add_index :reference_lookups, :canonical_full_name

    add_index :notes, :type
    add_index :notes, :owner_id
    add_index :notes, :visibility
    add_index :notes, :producer_canonical_name
    add_index :notes, :product_canonical_name

    add_index :producers, :type
    add_index :producers, :owner_id
    add_index :producers, :visibility
    add_index :producers, :canonical_name
  
    add_index :reference_producers, :type
    add_index :reference_producers, :canonical_name

    add_index :products, :type
    add_index :products, :owner_id
    add_index :products, :visibility
    add_index :products, :canonical_name
    add_index :products, :producer_canonical_name

    add_index :reference_products, :type
    add_index :reference_products, :canonical_name
    add_index :reference_products, :reference_producer_canonical_name
  
    add_index :resources, :resource_type

    add_index :tasters, :username
    add_index :tasters, :canonical_username
    add_index :tasters, :active
  end

  def self.down
  end
end
