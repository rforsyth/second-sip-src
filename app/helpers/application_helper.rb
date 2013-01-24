module ApplicationHelper

	def viewing_own_data?
		return displayed_taster.present? && (displayed_taster == current_taster)
	end
	
	def format_ugc(content)
	  simple_format(h(content))
  end
  
	def allow_edit?(object)
		return object.owner == current_taster
	end

	def format_note_title(note)
		title = "#{note.producer_name} #{note.product_name}"
		title << " #{note.vintage}" if note.vintage.present?
		return title
		#title << "(#{format_short_date(note.tasted_at)})"
	end

	def format_exception_title(exception)
		"#{exception.exception_class}: #{exception.controller_name}.#{exception.action_name}"
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
		@displayed_taster.nil?
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
	
	def default_score_type(note)
	  #return note.score_type if note.score_type.present?
	  if note.kind_of?(BeerNote)
	    return Enums::ScoreType::POINTS_50
	  else
	    return Enums::ScoreType::POINTS_100
	  end
  end
  
  def score_collection(note)
    collection = { nil => nil }
    score = note.kind_of?(BeerNote) ? 50 : 100
    while score > 0
      collection[score] = score
      score = score - 1
    end
    collection
  end
  
  def resource_type_name(resource_type)
    Enums::ResourceType.collection.each_pair do |name, type|
      return name if type == resource_type
    end
    nil
  end
  
  def link_to_external_resource(resource)
    return if !resource.url.present?
    case(resource.resource_type)
    when Enums::ResourceType::BJCP then
      link_to "BJCP: #{resource.title}", resource.url, :target => '_blank'
    end
      # <% if resource.url.present? %>
      #   <a href="<%= resource.url %>" target="_blank"> <%= resource.url %> </a>
      # <% end %>
    
  end
  
end
