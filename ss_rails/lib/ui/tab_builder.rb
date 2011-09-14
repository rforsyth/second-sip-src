require 'ui/navigation_tab'

module UI::TabBuilder
	
	def initialize_home_tabs
		@topnav_tabs = build_beverage_topnav_tabs(:home, displayed_taster, current_taster)
	end
	def initialize_global_notes_tabs
		initialize_global_beverage_tabs_helper(:global_notes)
	end
	def initialize_global_products_tabs
		initialize_global_beverage_tabs_helper(:global_products)
	end
	def initialize_global_producers_tabs
		initialize_global_beverage_tabs_helper(:global_producers)
	end
	def initialize_notes_tabs
		initialize_beverage_tabs_helper(calc_beverage_topnav, :notes)
	end
	def initialize_products_tabs
		initialize_beverage_tabs_helper(calc_beverage_topnav, :products)
	end
	def initialize_producers_tabs
		initialize_beverage_tabs_helper(calc_beverage_topnav, :producers)
	end
	def initialize_friendships_tabs
		initialize_admin_tabs_helper(:tasters, :friendships)
	end
	def initialize_lookups_tabs
		initialize_admin_tabs_helper(:lookups, :lookups)
	end
	def initialize_reference_lookups_tabs
		initialize_admin_tabs_helper(:lookups, :reference_lookups)
	end
	def initialize_tasters_admin_tabs
		initialize_admin_tabs_helper(:tasters, :tasters)
	end
	def initialize_tasters_tabs
		@topnav_tabs = [UI::NavigationTab.new(:home, nil),
		                UI::NavigationTab.new(:taster, 'selected')]
	end
	def initialize_tags_tabs
		initialize_admin_tabs_helper(:tags, :tags)
	end
	def initialize_admin_tags_tabs
		initialize_admin_tabs_helper(:tags, :admin_tags)
	end
	def initialize_reference_breweries_tabs
		initialize_admin_tabs_helper(:reference_producers, :reference_breweries)
	end
	def initialize_reference_wineries_tabs
		initialize_admin_tabs_helper(:reference_producers, :reference_wineries)
	end
	def initialize_reference_distilleries_tabs
		initialize_admin_tabs_helper(:reference_producers, :reference_distilleries)
	end
	def initialize_reference_beers_tabs
		initialize_admin_tabs_helper(:reference_products, :reference_beers)
	end
	def initialize_reference_wines_tabs
		initialize_admin_tabs_helper(:reference_products, :reference_wines)
	end
	def initialize_reference_spirits_tabs
		initialize_admin_tabs_helper(:reference_products, :reference_spirits)
	end
	def initialize_producer_edit_tabs
		@topnav_tabs = build_beverage_topnav_tabs(:my_notes, current_taster, current_taster)
		@subnav_tabs = build_beverage_subnav_tabs(:producers)
	end
	def initialize_product_edit_tabs
		@topnav_tabs = build_beverage_topnav_tabs(:my_notes, current_taster, current_taster)
		@subnav_tabs = build_beverage_subnav_tabs(:products)
	end
	def initialize_note_edit_tabs
		@topnav_tabs = build_beverage_topnav_tabs(:my_notes, current_taster, current_taster)
		@subnav_tabs = build_beverage_subnav_tabs(:notes)
	end
	def initialize_register_or_login_tabs
		@topnav_tabs = build_minimal_topnav_tabs
  end
	
	private
	
	def initialize_beverage_tabs_helper(topnav_tab, subnav_tab)
		@topnav_tabs = build_beverage_topnav_tabs(topnav_tab, displayed_taster, current_taster, (displayed_taster == current_taster))
		@subnav_tabs = build_beverage_subnav_tabs(subnav_tab)
	end
	
	def initialize_global_beverage_tabs_helper(subnav_tab)
		@topnav_tabs = build_beverage_topnav_tabs(:beverage, displayed_taster, current_taster, (displayed_taster == current_taster))
		@subnav_tabs = build_global_beverage_subnav_tabs(subnav_tab)
	end
	
	def initialize_admin_tabs_helper(topnav_tab, subnav_tab)
		@topnav_tabs = build_admin_topnav_tabs(topnav_tab)
		@subnav_tabs = case topnav_tab
			when :tasters then build_tasters_subnav_tabs(subnav_tab)
			when :lookups then build_lookups_subnav_tabs(subnav_tab)
			when :tags then build_tags_subnav_tabs(subnav_tab)
			when :reference_products then build_reference_products_subnav_tabs(subnav_tab)
			when :reference_producers then build_reference_producers_subnav_tabs(subnav_tab)
		end
	end
	
	def calc_beverage_topnav
		return :my_notes if displayed_taster == current_taster
		:taster
	end
	
	def build_minimal_topnav_tabs
		tabs = [UI::NavigationTab.new(:home, 'selected')]
  end
	
	def build_beverage_topnav_tabs(selected_tab, displayed_taster, current_taster, hide_taster_tab = false)
		tabs = []
		tabs << UI::NavigationTab.new(:home, calc_class(:home, selected_tab))
		if @product_class.present?
			tabs << UI::NavigationTab.new(:beverage, calc_class(:beverage, selected_tab))
		end
		if current_taster.present? && @beverage_type.present?
			tabs << UI::NavigationTab.new(:my_notes, calc_class(:my_notes, selected_tab))
		end
		if displayed_taster.present? && !hide_taster_tab
			tabs << UI::NavigationTab.new(:taster, calc_class(:taster, selected_tab))
		end
		tabs
	end
	
	def build_admin_topnav_tabs(selected_tab)
		tabs = [UI::NavigationTab.new(:tasters, calc_class(:tasters, selected_tab)),
		        UI::NavigationTab.new(:reference_producers, calc_class(:reference_producers, selected_tab)),
		        UI::NavigationTab.new(:reference_products, calc_class(:reference_products, selected_tab)),
		        UI::NavigationTab.new(:lookups, calc_class(:lookups, selected_tab)),
		        UI::NavigationTab.new(:tags, calc_class(:tags, selected_tab))]
		return tabs
	end

	def build_beverage_subnav_tabs(selected_tab)
		[UI::NavigationTab.new(:notes, calc_class(:notes, selected_tab)),
		 UI::NavigationTab.new(:products, calc_class(:products, selected_tab)),
		 UI::NavigationTab.new(:producers, calc_class(:producers, selected_tab))]
	end

	def build_global_beverage_subnav_tabs(selected_tab)
		[UI::NavigationTab.new(:global_notes, calc_class(:global_notes, selected_tab)),
		 UI::NavigationTab.new(:global_products, calc_class(:global_products, selected_tab)),
		 UI::NavigationTab.new(:global_producers, calc_class(:global_producers, selected_tab))]
	end
	
	def build_lookups_subnav_tabs(selected_tab)
		[UI::NavigationTab.new(:lookups, calc_class(:lookups, selected_tab)),
		 UI::NavigationTab.new(:reference_lookups, calc_class(:reference_lookups, selected_tab))]
	end
	
	def build_tags_subnav_tabs(selected_tab)
		[UI::NavigationTab.new(:tags, calc_class(:tags, selected_tab)),
		 UI::NavigationTab.new(:admin_tags, calc_class(:admin_tags, selected_tab))]
	end
	
	def build_tasters_subnav_tabs(selected_tab)
		[UI::NavigationTab.new(:tasters, calc_class(:tasters, selected_tab)),
		 UI::NavigationTab.new(:friendships, calc_class(:friendships, selected_tab))]
	end
	
	def build_reference_producers_subnav_tabs(selected_tab)
		[UI::NavigationTab.new(:reference_breweries, calc_class(:reference_breweries, selected_tab)),
		 UI::NavigationTab.new(:reference_wineries, calc_class(:reference_wineries, selected_tab)),
		 UI::NavigationTab.new(:reference_distilleries, calc_class(:reference_distilleries, selected_tab))]
	end
	
	def build_reference_products_subnav_tabs(selected_tab)
		[UI::NavigationTab.new(:reference_beers, calc_class(:reference_beers, selected_tab)),
		 UI::NavigationTab.new(:reference_wines, calc_class(:reference_wines, selected_tab)),
		 UI::NavigationTab.new(:reference_spirits, calc_class(:reference_spirits, selected_tab))]
	end
	
	def calc_class(current_tab, selected_tab)
		(current_tab == selected_tab) ? 'selected' : nil
	end
	
	
end