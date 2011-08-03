class Friendship < ActiveRecord::Base
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	belongs_to :inviter, :class_name => "Taster"
	belongs_to :invitee, :class_name => "Taster"
	
end
