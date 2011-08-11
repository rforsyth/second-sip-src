
module UI

	class NavigationTab
		attr_accessor :tab, :css_class, :container_object
	
		def initialize(tab, css_class = nil, container_object = nil)
			@tab = tab
			@css_class = css_class
			@container_object = container_object
		end
	end

end