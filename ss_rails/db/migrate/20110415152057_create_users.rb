class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :canonical_username
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :greeting
      t.boolean :is_banned

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
