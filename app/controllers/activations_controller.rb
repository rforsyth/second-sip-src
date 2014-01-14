
class ActivationsController < ApplicationController
  before_filter :require_no_taster
	#force_ssl :only => [:new, :create]

  def re_send
    @taster = Taster.find_by_email(params[:email])
    return render :action => :invalid_email, :layout => 'single_column' if @taster.nil?
    return render :action => :already_active, :layout => 'single_column' if @taster.active?
    @taster.deliver_activation_instructions!
    render :layout => 'single_column'
  end

  def new
    @taster = Taster.find_using_perishable_token(params[:activation_code], 1.week)
    return render :action => :not_found, :layout => 'single_column' if @taster.nil?
    return render :action => :already_active, :layout => 'single_column' if @taster.active?
  end

  def create
    @taster = Taster.find(params[:id])
    return render :action => :already_active, :layout => 'single_column' if @taster.active?

    if @taster.activate!(params)
      @taster.deliver_activation_confirmation!
      redirect_to @taster
    else
      render :action => :new
    end
  end

end
