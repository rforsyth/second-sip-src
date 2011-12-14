class HomeController < ApplicationController
	before_filter :initialize_home_tabs
  
  def index
    @beer_style_names = find_homepage_lookup_names(Enums::LookupType::STYLE, Beer.name)
    @beer_region_names = find_homepage_lookup_names(Enums::LookupType::REGION, Beer.name)
    @wine_varietal_names = find_homepage_lookup_names(Enums::LookupType::VARIETAL, Wine.name)
    @wine_region_names = find_homepage_lookup_names(Enums::LookupType::REGION, Wine.name)
    @spirit_style_names = find_homepage_lookup_names(Enums::LookupType::STYLE, Spirit.name)
    @spirit_region_names = find_homepage_lookup_names(Enums::LookupType::REGION, Spirit.name)
    
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
  
  def find_homepage_lookup_names(lookup_type, entity_type)
	  ActiveRecord::Base.connection.select_values("
      SELECT name FROM
      	(SELECT looked.id AS looked_id, lookups.name
      	FROM lookups, reference_lookups, looked
      	WHERE lookups.id = looked.lookup_id
      		AND lookups.canonical_name = reference_lookups.canonical_name
      		AND lookups.lookup_type = #{lookup_type}
      		AND lookups.entity_type = '#{entity_type}'
      	ORDER BY looked.id DESC
      	LIMIT 200) AS lookup_names
      GROUP BY name
      ORDER BY COUNT(looked_id) DESC
      LIMIT 5")
  end
  
  

end
