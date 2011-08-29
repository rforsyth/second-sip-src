class TastersController < ApplicationController
	before_filter :initialize_tasters_tabs, :only => [:show]
	before_filter :initialize_tasters_admin_tabs, :except => [:show]
	
  def index
    @tasters = Taster.all
  end

  def show
    @taster = Taster.find_by_username(params[:id])
    @displayed_taster = @taster
    @notes = Note.find_all_by_owner_id(@taster.id)
    
    if displayed_taster == current_taster
      @friendships = Friendship.where("status = ? AND (inviter_id = ? OR invitee_id = ?)",
                                       Enums::FriendshipStatus::ACCEPTED,
                                       current_taster.id, current_taster.id)
      @friendship_invitations = Friendship.where("status = ? AND invitee_id = ?",
                                       Enums::FriendshipStatus::REQUESTED,
                                       current_taster.id)
    end
  end
  
  def admin_profile
    @taster = Taster.find_by_username(params[:id])
  end
  
  def new
    @taster = Taster.new
  end
  
  def change_password
    @taster = Taster.find_by_username(params[:id])
  end

  def edit
    @taster = Taster.find_by_username(params[:id])
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
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions."
      render :action => "complete_verification"
      #redirect_to(@taster, :notice => 'Taster was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @taster = Taster.find_by_username(params[:id])
    @taster.update_profile(params)
    if @taster.save
      redirect_to(@taster, :notice => 'Taster was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @taster = Taster.find_by_username(params[:id])
    @taster.destroy
    redirect_to(tasters_url)
  end
end
