class Friendship < ActiveRecord::Base
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :inviter, :class_name => "Taster"
	belongs_to :invitee, :class_name => "Taster"
	
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
	
end
