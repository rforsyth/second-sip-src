class Friendship < ActiveRecord::Base
  nilify_blanks
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :inviter, :class_name => "Taster"
	belongs_to :invitee, :class_name => "Taster"
	
	validates_presence_of :inviter, :invitee, :creator, :updater, :invitation
	validate :friendship_does_not_exist, :on => :create

  def self.find_all_by_taster(taster)
    friendships = Friendship.where("status = ? AND (inviter_id = ? OR invitee_id = ?)",
                                   Enums::FriendshipStatus::ACCEPTED,
                                   taster.id, taster.id)
  end

  def deliver_invitation!
    Notifier.friendship_invitation(self).deliver
  end
	
	def status_message(current_taster)
		if self.status == Enums::FriendshipStatus::REQUESTED
			return "You have sent a friend invitation to #{self.invitee.username}." if current_taster == self.inviter
			return "#{self.inviter.username} has sent you a friend invitation." if current_taster == self.invitee
			return "#{self.inviter.username} sent a friend invitation to #{self.invitee.username}."
		elsif self.status == Enums::FriendshipStatus::ACCEPTED
			return "You are friends with #{self.invitee.username}." if current_taster == self.inviter
			return "You are friends with #{self.inviter.username}." if current_taster == self.invitee
			return "#{self.inviter.username} is friends with #{self.invitee.username}."			
		elsif self.status == Enums::FriendshipStatus::DECLINED
			return "#{self.invitee.username} declined your friend invitation." if current_taster == self.inviter
			return "You declined #{self.inviter.username}'s friend invitation." if current_taster == self.invitee
			return "#{self.invitee.username} declined #{self.inviter.username}'s friend invitation."
		else
			return "Unknown status: #{self.status}"
		end
	end
	
  private
  
  def friendship_does_not_exist
    friendships = Friendship.where("(invitee_id = ? AND inviter_id = ?) OR (inviter_id = ? AND invitee_id = ?)",
                               self.invitee_id, self.inviter_id, self.invitee_id, self.inviter_id)
    if friendships.count > 0
      errors.add(:inviter, "already exists.  If they are not in your list of friends then you may need to remind them to accept your invitation.") 
    end
  end
	
end
