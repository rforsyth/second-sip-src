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

ActiveRecord::Schema.define(:version => 20110901215501) do

  create_table "admin_tagged", :force => true do |t|
    t.integer "admin_tag_id",                       :null => false
    t.integer "admin_taggable_id",                  :null => false
    t.string  "admin_taggable_type", :limit => 100, :null => false
  end

  create_table "admin_tags", :force => true do |t|
    t.integer  "creator_id",                 :null => false
    t.integer  "updater_id",                 :null => false
    t.string   "name",        :limit => 150, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "entity_type", :limit => 50,  :null => false
  end

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

  create_table "looked", :force => true do |t|
    t.integer "lookup_id",                    :null => false
    t.integer "lookable_id",                  :null => false
    t.string  "lookable_type", :limit => 100, :null => false
    t.integer "owner_id",                     :null => false
  end

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

  create_table "notes", :force => true do |t|
    t.integer  "creator_id",                            :null => false
    t.integer  "updater_id",                            :null => false
    t.string   "type",                   :limit => 50,  :null => false
    t.integer  "owner_id",                              :null => false
    t.integer  "visibility",                            :null => false
    t.integer  "product_id",                            :null => false
    t.text     "description_overall"
    t.string   "description_appearance", :limit => 500
    t.string   "description_aroma",      :limit => 500
    t.string   "description_flavor",     :limit => 500
    t.string   "description_mouthfeel",  :limit => 500
    t.datetime "tasted_at",                             :null => false
    t.integer  "score_type"
    t.float    "score"
    t.integer  "buy_when"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "vintage"
  end

  create_table "producers", :force => true do |t|
    t.integer  "creator_id",                    :null => false
    t.integer  "updater_id",                    :null => false
    t.string   "type",           :limit => 50,  :null => false
    t.integer  "owner_id",                      :null => false
    t.integer  "visibility",                    :null => false
    t.string   "website_url",    :limit => 500
    t.string   "name",           :limit => 150, :null => false
    t.string   "canonical_name", :limit => 150, :null => false
    t.text     "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "products", :force => true do |t|
    t.integer  "creator_id",                    :null => false
    t.integer  "updater_id",                    :null => false
    t.string   "type",           :limit => 50,  :null => false
    t.integer  "owner_id",                      :null => false
    t.integer  "visibility",                    :null => false
    t.integer  "producer_id",                   :null => false
    t.string   "name",           :limit => 150, :null => false
    t.string   "canonical_name", :limit => 150, :null => false
    t.text     "description"
    t.float    "price"
    t.float    "price_paid"
    t.integer  "price_type"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "reference_looked", :force => true do |t|
    t.integer "reference_lookup_id",                    :null => false
    t.integer "reference_lookable_id",                  :null => false
    t.string  "reference_lookable_type", :limit => 100, :null => false
  end

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

  create_table "reference_producers", :force => true do |t|
    t.integer  "creator_id",                    :null => false
    t.integer  "updater_id",                    :null => false
    t.string   "type",           :limit => 100, :null => false
    t.string   "website_url",    :limit => 500
    t.string   "name",           :limit => 150
    t.string   "canonical_name", :limit => 150
    t.text     "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "reference_products", :force => true do |t|
    t.integer  "creator_id",                           :null => false
    t.integer  "updater_id",                           :null => false
    t.string   "type",                  :limit => 100, :null => false
    t.integer  "reference_producer_id",                :null => false
    t.string   "name",                  :limit => 150
    t.string   "canonical_name",        :limit => 150
    t.text     "description"
    t.float    "price"
    t.integer  "price_type"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "resources", :force => true do |t|
    t.integer  "creator_id",                   :null => false
    t.integer  "updater_id",                   :null => false
    t.string   "title",         :limit => 150, :null => false
    t.text     "body"
    t.text     "wiki_text"
    t.string   "url",           :limit => 500
    t.integer  "resource_type",                :null => false
    t.integer  "lookup_id",                    :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "tagged", :force => true do |t|
    t.integer "tag_id",                       :null => false
    t.integer "taggable_id",                  :null => false
    t.string  "taggable_type", :limit => 100, :null => false
    t.integer "owner_id",                     :null => false
  end

  create_table "tags", :force => true do |t|
    t.integer  "creator_id",                 :null => false
    t.integer  "updater_id",                 :null => false
    t.string   "name",        :limit => 150, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "entity_type", :limit => 50,  :null => false
  end

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

  add_index "tasters", ["email"], :name => "index_tasters_on_email"
  add_index "tasters", ["perishable_token"], :name => "index_tasters_on_perishable_token"

end
