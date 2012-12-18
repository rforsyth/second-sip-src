require 'data/admin_taggable'

class Taster < ActiveRecord::Base
  include PgSearch
  include Data::AdminTaggable
  nilify_blanks
  
  USERNAME_PATTERN = /^[a-zA-Z][a-zA-Z0-9_]*[a-zA-Z0-9]$/
  
  attr_protected :username, :email, :password, :password_confirmation
	belongs_to :creator, :class_name => "Taster"
	belongs_to :updater, :class_name => "Taster"
	
  acts_as_authentic do |c|
    c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
    c.validates_length_of_password_confirmation_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
    c.validates_format_of_login_field_options = {:with => USERNAME_PATTERN,
        :message => 'should use only letters, numbers, and underscores, starting with a letter (ex: Jane_Doe)'}
    c.validates_length_of_login_field_options = {:within => 4..20,
        :message => 'should be between 4 and 20 characters long'}
    c.perishable_token_valid_for = 1.hour
  end
  
  before_validation :set_canonical_fields
  before_create :add_unreviewed_tag
  
	validates_presence_of :username, :email, :real_name

  ROLES = %w[admin enforcer editor banned]
  
  pg_search_scope :search,
    :against => [:username, :real_name, :email, :greeting]
    #:ignoring => :accents
  
  # we need to make sure a password gets set when the user activates their account
  def has_no_credentials?
    self.crypted_password.blank?
  end
  
  # called at registration - before validation email is sent
  def signup!(params)
    update_profile(params)
    self.email = params[:taster][:email]
    save_without_session_maintenance
  end
  
  # called at validation
  def activate!(params)
    self.active = true
    self.password = params[:taster][:password]
    self.password_confirmation = params[:taster][:password_confirmation]
    save
  end
  
  def update_profile(params)
    self.username = params[:taster][:username]
    self.greeting = params[:taster][:greeting]
    self.real_name = params[:taster][:real_name]
  end
  
  def set_canonical_fields
    self.canonical_username = self.username.canonicalize if self.username.present?
  end
  
  def to_param
    self.username
  end
  
  def friends
    friendships = Friendship.find_all_by_taster(self)
    friendships.collect do |friendship|
      (friendship.invitee.id == self.id) ? friendship.inviter : friendship.invitee
    end 
  end
  
  ############################################
  ## Account Management
  
  # supports logging in via either username or email address
  def self.find_by_username_or_email(login)
    taster = Taster.find(:first, :conditions => [ "lower(username) = ?", login.downcase ])
    taster || find_by_email(login)
    #find_by_username(login) || find_by_email(login)
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    Notifier.password_reset_instructions(self).deliver
  end
  
  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.activation_instructions(self).deliver
  end
 
  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.activation_confirmation(self).deliver
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
	

  ############################################
  ## API
	
	def api_copy
	  copy = ApiTaster.new
	  copy.id = self.id
	  copy.username = self.username
	  copy.real_name = self.real_name
	  return copy
  end
	

end

class ApiTaster
	attr_accessor :id, :username, :real_name
end


