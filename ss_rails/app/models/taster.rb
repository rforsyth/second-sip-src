class Taster < ActiveRecord::Base
  set_table_name "users"
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
  acts_as_authentic

  ROLES = %w[admin enforcer editor banned]
  
  def to_param
    self.username
  end

  ############################################
  ## Authorization

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
