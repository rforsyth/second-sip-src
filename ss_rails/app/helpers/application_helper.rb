module ApplicationHelper

	def viewing_own_data?
		return displayed_taster.present? && (displayed_taster == current_taster)
	end
  
	def allow_edit?(object)
		return object.owner == current_taster
	end

	def format_note_title(note)
		"#{note.producer_name} #{note.product_name} (#{format_short_date(note.tasted_at)})"
	end

	def format_short_date(date)
		if date.year == Time.now.year then
			#"#{date.month.to_s}/#{date.day.to_s}"
			"#{date.strftime("%b")} #{date.day.to_s}"
		else
			#"#{date.month.to_s}/#{date.day.to_s}/#{(date.year - 2000).to_s}"
			"#{date.strftime("%b")} #{date.day.to_s}, #{(date.year).to_s}"
		end
	end

	def format_long_date(date)
		"#{date.strftime("%B")} #{date.day.to_s}, #{(date.year).to_s}"
	end
	
	def search_results_title
		"Search Results for \"#{params[:query]}\""
	end
	
	def show_list_item_username
		@displayed_profile.nil?
	end
	
	def calculate_body_class
	  case params[:controller]
    when 'global_notes', 'global_products', 'global_producers' then
      params[:entity_type]
    else
      params[:controller]
    end
  end
  
	def page_path(page_num)
		page_params = params.dup
		page_params[:page] = page_num
		return url_for(page_params)
	end
  
end
