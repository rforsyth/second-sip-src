require 'ui/admin_taggable_controller'

class TastersController < ApplicationController
  include UI::AdminTaggableController
  
  before_filter :find_taster, :only => [ :admin_profile, :show, :edit, :update,
                                         :add_admin_tag, :remove_admin_tag ]
  before_filter :set_tag_container, :only => [ :add_admin_tag, :remove_admin_tag ]
	before_filter :initialize_tasters_tabs, :only => [:show, :edit]
	before_filter :initialize_register_or_login_tabs, :only => [:new]
  before_filter :require_no_taster, :only => [:new, :create]
	
  def search
    @tasters = Taster.search(params[:query]).limit(MAX_BEVERAGE_RESULTS)
  end
  
  def index
    @tasters = find_by_admin_tags(Taster, params[:ain])
    build_admin_tag_filter(@tasters)
  end

  def show
    @displayed_taster = @taster
    @notes = Note.find_all_by_owner_id(@taster.id)
    
    if displayed_taster == current_taster
      @friendships = Friendship.find_all_by_taster(current_taster)
      @friendship_invitations = Friendship.where("status = ? AND invitee_id = ?",
                                       Enums::FriendshipStatus::REQUESTED,
                                       current_taster.id)
    end
  end
  
  def admin_profile
  end
  
  def new
    @taster = Taster.new
  end

  def create
    if(@taster = Taster.find_by_email(params[:taster][:email]))
      @taster.deliver_activation_instructions!
      return render :action => @taster.active? ? 'attempted_to_register_active_account' :
                                                 'attempted_to_register_inactive_account'
    else
      @taster = Taster.new
    end

    if @taster.signup!(params)
      @taster.deliver_activation_instructions!
      render :action => "complete_verification", :layout => 'single_column'
    else
      render :action => "new"
    end
  end

  def edit
    @displayed_taster = @taster  # the topnav tab needs this to be set
  end

  def update
    @taster.update_profile(params)
    if @taster.save
      redirect_to(@taster, :notice => 'Taster was successfully updated.')
    else
      render :action => "edit"
    end
  end
  
  def change_password
  end
	
  ############################################
  ## Helpers
	
	private
	
	def find_taster
    @taster = Taster.find_by_username(params[:id])
  end
  
  def set_tag_container
    @tag_container = @taster
  end
  
end
