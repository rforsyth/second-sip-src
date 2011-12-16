# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111216195155) do

  create_table "admin_tagged", :force => true do |t|
    t.integer "admin_tag_id",                       :null => false
    t.integer "admin_taggable_id",                  :null => false
    t.string  "admin_taggable_type", :limit => 100, :null => false
  end

  add_index "admin_tagged", ["admin_taggable_id"], :name => "index_admin_tagged_on_admin_taggable_id"
  add_index "admin_tagged", ["admin_taggable_type"], :name => "index_admin_tagged_on_admin_taggable_type"

  create_table "admin_tags", :force => true do |t|
    t.integer  "creator_id",                 :null => false
    t.integer  "updater_id",                 :null => false
    t.string   "name",        :limit => 150, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "entity_type", :limit => 50,  :null => false
  end

  add_index "admin_tags", ["entity_type"], :name => "index_admin_tags_on_entity_type"
  add_index "admin_tags", ["name"], :name => "index_admin_tags_on_name"

  create_table "friendships", :force => true do |t|
    t.integer  "creator_id", :null => false
    t.integer  "updater_id", :null => false
    t.integer  "inviter_id", :null => false
    t.integer  "invitee_id", :null => false
    t.text     "invitation", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "status",     :null => false
  end

  add_index "friendships", ["invitee_id"], :name => "index_friendships_on_invitee_id"
  add_index "friendships", ["inviter_id"], :name => "index_friendships_on_inviter_id"
  add_index "friendships", ["status"], :name => "index_friendships_on_status"

  create_table "looked", :force => true do |t|
    t.integer "lookup_id",                    :null => false
    t.integer "lookable_id",                  :null => false
    t.string  "lookable_type", :limit => 100, :null => false
    t.integer "owner_id",                     :null => false
  end

  add_index "looked", ["lookable_id"], :name => "index_looked_on_lookable_id"
  add_index "looked", ["lookable_type"], :name => "index_looked_on_lookable_type"
  add_index "looked", ["owner_id"], :name => "index_looked_on_owner_id"

  create_table "lookups", :force => true do |t|
    t.string   "name",           :limit => 150, :null => false
    t.string   "canonical_name", :limit => 150, :null => false
    t.text     "description"
    t.integer  "lookup_type",                   :null => false
    t.string   "entity_type",    :limit => 50,  :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "creator_id",                    :null => false
    t.integer  "updater_id",                    :null => false
    t.integer  "owner_id",                      :null => false
  end

  add_index "lookups", ["canonical_name"], :name => "index_lookups_on_canonical_name"
  add_index "lookups", ["entity_type"], :name => "index_lookups_on_entity_type"
  add_index "lookups", ["lookup_type"], :name => "index_lookups_on_lookup_type"
  add_index "lookups", ["owner_id"], :name => "index_lookups_on_owner_id"

  create_table "notes", :force => true do |t|
    t.integer  "creator_id",                             :null => false
    t.integer  "updater_id",                             :null => false
    t.string   "type",                    :limit => 50,  :null => false
    t.integer  "owner_id",                               :null => false
    t.integer  "visibility",                             :null => false
    t.integer  "product_id",                             :null => false
    t.text     "description_overall"
    t.string   "description_appearance",  :limit => 500
    t.string   "description_aroma",       :limit => 500
    t.string   "description_flavor",      :limit => 500
    t.string   "description_mouthfeel",   :limit => 500
    t.datetime "tasted_at",                              :null => false
    t.integer  "score_type"
    t.float    "score"
    t.integer  "buy_when"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "vintage"
    t.string   "searchable_metadata",     :limit => 500
    t.string   "producer_name",           :limit => 150, :null => false
    t.string   "producer_canonical_name", :limit => 150, :null => false
    t.string   "product_name",            :limit => 150, :null => false
    t.string   "product_canonical_name",  :limit => 150, :null => false
  end

  add_index "notes", ["owner_id"], :name => "index_notes_on_owner_id"
  add_index "notes", ["producer_canonical_name"], :name => "index_notes_on_producer_canonical_name"
  add_index "notes", ["product_canonical_name"], :name => "index_notes_on_product_canonical_name"
  add_index "notes", ["type"], :name => "index_notes_on_type"
  add_index "notes", ["visibility"], :name => "index_notes_on_visibility"

  create_table "producers", :force => true do |t|
    t.integer  "creator_id",                         :null => false
    t.integer  "updater_id",                         :null => false
    t.string   "type",                :limit => 50,  :null => false
    t.integer  "owner_id",                           :null => false
    t.integer  "visibility",                         :null => false
    t.string   "website_url",         :limit => 500
    t.string   "name",                :limit => 150, :null => false
    t.string   "canonical_name",      :limit => 150, :null => false
    t.text     "description"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "searchable_metadata", :limit => 500
  end

  add_index "producers", ["canonical_name"], :name => "index_producers_on_canonical_name"
  add_index "producers", ["owner_id"], :name => "index_producers_on_owner_id"
  add_index "producers", ["type"], :name => "index_producers_on_type"
  add_index "producers", ["visibility"], :name => "index_producers_on_visibility"

  create_table "products", :force => true do |t|
    t.integer  "creator_id",                             :null => false
    t.integer  "updater_id",                             :null => false
    t.string   "type",                    :limit => 50,  :null => false
    t.integer  "owner_id",                               :null => false
    t.integer  "visibility",                             :null => false
    t.integer  "producer_id",                            :null => false
    t.string   "name",                    :limit => 150, :null => false
    t.string   "canonical_name",          :limit => 150, :null => false
    t.text     "description"
    t.float    "price"
    t.float    "price_paid"
    t.integer  "price_type"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "searchable_metadata",     :limit => 500
    t.string   "producer_name",           :limit => 150, :null => false
    t.string   "producer_canonical_name", :limit => 150, :null => false
  end

  add_index "products", ["canonical_name"], :name => "index_products_on_canonical_name"
  add_index "products", ["owner_id"], :name => "index_products_on_owner_id"
  add_index "products", ["producer_canonical_name"], :name => "index_products_on_producer_canonical_name"
  add_index "products", ["type"], :name => "index_products_on_type"
  add_index "products", ["visibility"], :name => "index_products_on_visibility"

  create_table "reference_looked", :force => true do |t|
    t.integer "reference_lookup_id",                    :null => false
    t.integer "reference_lookable_id",                  :null => false
    t.string  "reference_lookable_type", :limit => 100, :null => false
  end

  add_index "reference_looked", ["reference_lookable_id"], :name => "index_reference_looked_on_reference_lookable_id"
  add_index "reference_looked", ["reference_lookable_type"], :name => "index_reference_looked_on_reference_lookable_type"

  create_table "reference_lookups", :force => true do |t|
    t.string   "name",                       :limit => 150, :null => false
    t.string   "canonical_name",             :limit => 150, :null => false
    t.text     "description"
    t.integer  "lookup_type",                               :null => false
    t.string   "entity_type",                :limit => 50,  :null => false
    t.integer  "parent_reference_lookup_id"
    t.string   "full_name",                  :limit => 500, :null => false
    t.string   "canonical_full_name",        :limit => 500, :null => false
    t.integer  "creator_id",                                :null => false
    t.integer  "updater_id",                                :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "reference_lookups", ["canonical_full_name"], :name => "index_reference_lookups_on_canonical_full_name"
  add_index "reference_lookups", ["canonical_name"], :name => "index_reference_lookups_on_canonical_name"
  add_index "reference_lookups", ["entity_type"], :name => "index_reference_lookups_on_entity_type"
  add_index "reference_lookups", ["lookup_type"], :name => "index_reference_lookups_on_lookup_type"

  create_table "reference_producers", :force => true do |t|
    t.integer  "creator_id",                         :null => false
    t.integer  "updater_id",                         :null => false
    t.string   "type",                :limit => 100, :null => false
    t.string   "website_url",         :limit => 500
    t.string   "name",                :limit => 150
    t.string   "canonical_name",      :limit => 150
    t.text     "description"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "searchable_metadata", :limit => 500
  end

  add_index "reference_producers", ["canonical_name"], :name => "index_reference_producers_on_canonical_name"
  add_index "reference_producers", ["type"], :name => "index_reference_producers_on_type"

  create_table "reference_products", :force => true do |t|
    t.integer  "creator_id",                                       :null => false
    t.integer  "updater_id",                                       :null => false
    t.string   "type",                              :limit => 100, :null => false
    t.integer  "reference_producer_id",                            :null => false
    t.string   "name",                              :limit => 150
    t.string   "canonical_name",                    :limit => 150
    t.text     "description"
    t.float    "price"
    t.integer  "price_type"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "searchable_metadata",               :limit => 500
    t.float    "price_paid"
    t.string   "reference_producer_name",           :limit => 150, :null => false
    t.string   "reference_producer_canonical_name", :limit => 150, :null => false
  end

  add_index "reference_products", ["canonical_name"], :name => "index_reference_products_on_canonical_name"
  add_index "reference_products", ["reference_producer_canonical_name"], :name => "index_reference_products_on_reference_producer_canonical_name"
  add_index "reference_products", ["type"], :name => "index_reference_products_on_type"

  create_table "resources", :force => true do |t|
    t.integer  "creator_id",                         :null => false
    t.integer  "updater_id",                         :null => false
    t.string   "title",               :limit => 150, :null => false
    t.text     "body"
    t.text     "wiki_text"
    t.string   "url",                 :limit => 500
    t.integer  "resource_type",                      :null => false
    t.integer  "reference_lookup_id",                :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "resources", ["resource_type"], :name => "index_resources_on_resource_type"

  create_table "tagged", :force => true do |t|
    t.integer "tag_id",                       :null => false
    t.integer "taggable_id",                  :null => false
    t.string  "taggable_type", :limit => 100, :null => false
    t.integer "owner_id",                     :null => false
  end

  add_index "tagged", ["owner_id"], :name => "index_tagged_on_owner_id"
  add_index "tagged", ["taggable_id"], :name => "index_tagged_on_taggable_id"
  add_index "tagged", ["taggable_type"], :name => "index_tagged_on_taggable_type"

  create_table "tags", :force => true do |t|
    t.integer  "creator_id",                 :null => false
    t.integer  "updater_id",                 :null => false
    t.string   "name",        :limit => 150, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "entity_type", :limit => 50,  :null => false
  end

  add_index "tags", ["entity_type"], :name => "index_tags_on_entity_type"
  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "tasters", :force => true do |t|
    t.string   "username",           :limit => 100,                     :null => false
    t.string   "canonical_username", :limit => 100,                     :null => false
    t.string   "email",              :limit => 150,                     :null => false
    t.string   "crypted_password",   :limit => 500
    t.string   "password_salt",      :limit => 500
    t.string   "persistence_token",  :limit => 500,                     :null => false
    t.string   "greeting",           :limit => 1000
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.integer  "roles_mask"
    t.string   "real_name",          :limit => 150
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.string   "perishable_token",                   :default => "",    :null => false
    t.boolean  "active",                             :default => false
  end

  add_index "tasters", ["active"], :name => "index_tasters_on_active"
  add_index "tasters", ["canonical_username"], :name => "index_tasters_on_canonical_username"
  add_index "tasters", ["email"], :name => "index_tasters_on_email"
  add_index "tasters", ["perishable_token"], :name => "index_tasters_on_perishable_token"
  add_index "tasters", ["username"], :name => "index_tasters_on_username"

end
