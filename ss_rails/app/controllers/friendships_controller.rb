class FriendshipsController < ApplicationController
	before_filter :initialize_friendships_tabs, :only => [:index, :show]
  
  def index
    @friendships = Friendship.all
  end

  def show
    @friendship = Friendship.find(params[:id])
  end

  def new
    @friendship = Friendship.new
		@friendship.invitation = <<-eos
I'd like to add you as a friend on Second Sip.

- #{current_taster.real_name} (#{current_taster.username})
eos
  end

  def edit
    @friendship = Friendship.find(params[:id])
  end

  def create
    @friendship = Friendship.new(params[:friendship])
    @friendship.inviter = current_taster
    @friendship.invitee = Taster.find_by_username(params[:invitee_username])
    @friendship.status = Enums::FriendshipStatus::REQUESTED
    if @friendship.save
      redirect_to(current_taster)
    else
      render :action => "new"
    end
  end

  def update
    @friendship = Friendship.find(params[:id])
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

end
