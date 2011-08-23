
class ActivationsController < ApplicationController
  before_filter :require_no_taster, :only => [:new, :create]

  def new
    @taster = Taster.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @taster.active?
  end

  def create
    @taster = Taster.find(params[:id])

    raise Exception if @taster.active?

    if @taster.activate!(params)
      @taster.deliver_activation_confirmation!
      redirect_to @taster
    else
      render :action => :new
    end
  end

end
