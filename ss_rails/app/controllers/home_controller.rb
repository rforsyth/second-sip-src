class HomeController < ApplicationController
	before_filter :initialize_home_tabs
  
  def index
		render :layout => 'single_column'
  end
  
  def about
		render :layout => 'single_column'
  end
  
  def contact
		render :layout => 'single_column'
  end
  
  def terms
		render :layout => 'single_column'
  end

end
