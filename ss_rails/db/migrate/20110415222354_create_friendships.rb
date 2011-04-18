class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.integer :creator_id
      t.integer :updater_id
      t.integer :inviter_id
      t.integer :invitee_id
      t.text :invitation

      t.timestamps
    end
  end

  def self.down
    drop_table :friendships
  end
end
