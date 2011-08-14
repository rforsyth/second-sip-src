class HomeController < ApplicationController
	before_filter :initialize_home_tabs
  
  def index
		render :layout => 'single_column'
  end

end
