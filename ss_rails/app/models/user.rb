class User < ActiveRecord::Base
	belongs_to :creator, :class_name => "User"
	belongs_to :updater, :class_name => "User"
  acts_as_authentic

  ROLES = %w[admin enforcer editor banned]

	def is?(role)
	  roles.include?(role.to_s)
	end

	def roles=(roles)
	  self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
	end

	def roles
	  ROLES.reject do |r|
	    ((roles_mask || 0) & 2**ROLES.index(r)).zero?
	  end
	end

end
