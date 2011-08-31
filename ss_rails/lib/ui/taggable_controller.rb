
module UI
  module TaggableController
	  
  	def add_tag
      @tags = @tag_container.add_tag(params[:tag_name])
  		render :template => 'common/ajax/tags', :layout => false
  	end

  	def remove_tag
      @tags = @tag_container.remove_tag(params[:tag_name])
  		render :template => 'common/ajax/tags', :layout => false
  	end
	
  end
end