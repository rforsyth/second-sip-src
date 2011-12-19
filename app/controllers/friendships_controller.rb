class FriendshipsController < ApplicationController
	before_filter :initialize_friendships_tabs, :only => [:index, :show]
	before_filter :require_admin, :except => [:new, :edit, :create, :update]
	before_filter :require_taster, :only => [:edit, :update]
	before_filter :require_invitee, :only => [:edit, :update]
  
  def index
    @friendships = Friendship.all
  end

  def show
    @friendship = Friendship.find(params[:id])
  end

  def new
    @friendship = Friendship.new
		@friendship.invitation = <<-eos
I'd like to add you as a friend on Second Sip so that we can share tasting notes.

- #{current_taster.real_name} (#{current_taster.username})
eos
  end

  def edit
  end

  def create
    @friendship = Friendship.new(params[:friendship])
    @friendship.inviter = current_taster
    invitee = Taster.find_by_username(params[:invitee_username])
    if invitee.nil?
      @friendship.errors.add(:invitee, "#{params[:invitee_username]} was not found in our database.")
      return render :action => "new"
    end
    @friendship.invitee = invitee
    @friendship.status = Enums::FriendshipStatus::REQUESTED
    if @friendship.save
      @friendship.deliver_invitation!
      render :action => "success", :layout => 'single_column'
    else
      render :action => "new"
    end
  end

  def update
		@friendship.status = case params[:commit]
		when 'Accept' then Enums::FriendshipStatus::ACCEPTED
		when 'Decline' then Enums::FriendshipStatus::DECLINED
	  end
    if @friendship.save
      redirect_to(current_taster)
    else
      render :action => "edit"
    end
  end
  
  def require_invitee
    @friendship = Friendship.find(params[:id])
    if !@friendship.present?
      flash[:notice] = "Invitation not found." 
      render :template => 'errors/message', :layout => 'single_column', :status => 500
      return false
    end
    if !(current_taster && current_taster == @friendship.invitee)
      flash[:notice] = "You do not have permission to access this page." 
      render :template => 'errors/message', :layout => 'single_column', :status => :forbidden
      return false
    end
  end

end
