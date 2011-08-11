
require 'ui/navigation_tab'

module UI::TabBuilder
	
	def initialize_home_tabs
		@topnav_tabs = build_beverage_topnav_tabs(:home, @displayed_taster, @current_taster)
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
		initialize_admin_tabs_helper(:users, :friendships)
	end
	def initialize_lookups_tabs
		initialize_admin_tabs_helper(:metadata, :lookups)
	end
	def initialize_taster_home_tabs
		@topnav_tabs = build_beverage_topnav_tabs(:user, @displayed_taster, @current_taster)
	end
	def initialize_tasters_tabs
		initialize_admin_tabs_helper(:users, :tasters)
	end
	def initialize_references_tabs
		initialize_admin_tabs_helper(:metadata, :references)
	end
	def initialize_tags_tabs
		initialize_admin_tabs_helper(:metadata, :tags)
	end
	def initialize_producer_edit_tabs
		@topnav_tabs = build_beverage_topnav_tabs(:my_notes, @current_taster, @current_taster)
		@subnav_tabs = build_beverage_subnav_tabs(:producers)
	end
	def initialize_product_edit_tabs
		@topnav_tabs = build_beverage_topnav_tabs(:my_notes, @current_taster, @current_taster)
		@subnav_tabs = build_beverage_subnav_tabs(:products)
	end
	def initialize_note_edit_tabs
		@topnav_tabs = build_beverage_topnav_tabs(:my_notes, @current_taster, @current_taster)
		@subnav_tabs = build_beverage_subnav_tabs(:notes)
	end
	
	private
	
	def initialize_beverage_tabs_helper(topnav_tab, subnav_tab)
		@topnav_tabs = build_beverage_topnav_tabs(topnav_tab, @displayed_taster, @current_taster, (@displayed_taster == @current_taster))
		@subnav_tabs = build_beverage_subnav_tabs(subnav_tab)
	end
	
	def initialize_admin_tabs_helper(topnav_tab, subnav_tab)
		@topnav_tabs = build_admin_topnav_tabs(topnav_tab)
		@subnav_tabs = case topnav_tab
			when :metadata then build_metadata_subnav_tabs(subnav_tab)
			when :users then build_users_subnav_tabs(subnav_tab)
		end
	end
	
	def calc_beverage_topnav
		return :beverage if @displayed_taster.nil?
		return :my_notes if @displayed_taster == @current_taster
		:user
	end
	
	def build_beverage_topnav_tabs(selected_tab, displayed_taster, current_taster, hide_user_tab = false)
		tabs = []
		tabs << UI::NavigationTab.new(:home, calc_class(:home, selected_tab))
		if @product_class.present?
			tabs << UI::NavigationTab.new(:beverage, calc_class(:beverage, selected_tab))
		end
		if @current_taster.present? && @beverage_type.present?
			tabs << UI::NavigationTab.new(:my_notes, calc_class(:my_notes, selected_tab))
		end
		if @displayed_taster.present? && !hide_user_tab
			tabs << UI::NavigationTab.new(:user, calc_class(:user, selected_tab))
		end
		tabs
	end
	
	def build_admin_topnav_tabs(selected_tab)
		tabs = [UI::NavigationTab.new(:home, calc_class(:home, selected_tab)),
		 UI::NavigationTab.new(:users, calc_class(:users, selected_tab)),
		 UI::NavigationTab.new(:metadata, calc_class(:metadata, selected_tab))]
		tabs << UI::NavigationTab.new(:my_notes, calc_class(:my_notes, selected_tab)) if @beverage_type.present?
		return tabs
	end

	def build_beverage_subnav_tabs(selected_tab)
		[UI::NavigationTab.new(:notes, calc_class(:notes, selected_tab)),
		 UI::NavigationTab.new(:products, calc_class(:products, selected_tab)),
		 UI::NavigationTab.new(:producers, calc_class(:producers, selected_tab))]
	end
	
	def build_metadata_subnav_tabs(selected_tab)
		[UI::NavigationTab.new(:lookups, calc_class(:lookups, selected_tab)),
		 UI::NavigationTab.new(:references, calc_class(:references, selected_tab)),
		 UI::NavigationTab.new(:tags, calc_class(:tags, selected_tab))]
	end
	
	def build_users_subnav_tabs(selected_tab)
		[UI::NavigationTab.new(:tasters, calc_class(:tasters, selected_tab)),
		 UI::NavigationTab.new(:friendships, calc_class(:friendships, selected_tab))]
	end
	
	def calc_class(current_tab, selected_tab)
		(current_tab == selected_tab) ? 'selected' : nil
	end
	
	
end