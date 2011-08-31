
module UI
  module AdminTaggableController	  

  	def add_admin_tag
      @admin_tags = @tag_container.add_admin_tag(params[:tag_name])
  		render :template => 'common/ajax/admin_tags', :layout => false
  	end

  	def remove_admin_tag
      @admin_tags = @tag_container.remove_admin_tag(params[:tag_name])
  		render :template => 'common/ajax/admin_tags', :layout => false
  	end
	
  end
end