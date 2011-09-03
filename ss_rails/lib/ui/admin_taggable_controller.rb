
module UI
  module AdminTaggableController	
	  
	  def self.find_by_owner_and_admin_tags(owner, tags)
      if params[:in].present?
        return self.find_by_sql(
          ["SELECT DISTINCT <%= self.table_name %>.* FROM <%= self.table_name %> 
            INNER JOIN admin_tagged ON <%= self.table_name %>.id = admin_tagged.admin_taggable_id
            INNER JOIN admin_tags ON admin_tagged.admin_tag_id = admin_tags.id
            WHERE <%= self.table_name %>.owner_id = ?
              AND <%= self.table_name %>.type = ?
              AND admin_tags.name IN (?)",
            owner.id, self.name, tags])
      else
        return self.find_all_by_owner_id(owner.id)
      end
    end
    
    def self.find_by_admin_tags(tags)
      
    end

  	def add_admin_tag
      tags = @tag_container.add_admin_tag(params[:tag_name])
      @admin_tags = tags.collect{|tag| tag.name}
  		render :template => 'common/ajax/admin_tags', :layout => false
  	end

  	def remove_admin_tag
      tags = @tag_container.remove_admin_tag(params[:tag_name])
      @admin_tags = tags.collect{|tag| tag.name}
  		render :template => 'common/ajax/admin_tags', :layout => false
  	end
	
  end
end