SsRails::Application.routes.draw do

  resources :admin_tags

  username_pattern = /[a-zA-Z0-9_]{3,16}/  # no anchor characters required in routes
	producers_pattern = /breweries|wineries|distilleries/
	products_pattern = /beers|wines|spirits/
	notes_pattern = /beer_notes|wine_notes|spirit_notes/
	
	
	resources :ng, :controller => 'angular'

  resources :api_sessions, :controller => 'api_sessions'

  #constraints :subdomain => 'api' do
    
	  match '/api_startup/configuration' => "api_startup#configuration", :as => :api_startup_configuration
	  match '/api_startup/register' => "api_startup#register", :as => :api_register
	  match '/api_startup/forgot_password' => "api_startup#forgot_password", :as => :api_forgot_password
    
    resources :api_wineries, :controller => 'api_wineries' do
                get 'search', :on => :collection
                get 'autocomplete', :on => :collection
                get 'tag_autocomplete', :on => :collection
                get 'common_tags', :on => :collection
                get 'lookup_autocomplete', :on => :collection
                get 'show_simple', :on => :collection
              end
    resources :api_wines, :controller => 'api_wines' do
                get 'search', :on => :collection
                get 'autocomplete', :on => :collection
                get 'tag_autocomplete', :on => :collection
                get 'common_tags', :on => :collection
                get 'lookup_autocomplete', :on => :collection
                get 'show_simple', :on => :collection
              end
    resources :api_wine_notes, :controller => 'api_wine_notes' do
                get 'search', :on => :collection
                get 'tag_autocomplete', :on => :collection
                get 'common_tags', :on => :collection
                get 'lookup_autocomplete', :on => :collection
              end
              
    resources :api_breweries, :controller => 'api_breweries' do
                get 'search', :on => :collection
                get 'autocomplete', :on => :collection
                get 'tag_autocomplete', :on => :collection
                get 'common_tags', :on => :collection
                get 'lookup_autocomplete', :on => :collection
                get 'show_simple', :on => :collection
              end
    resources :api_beers, :controller => 'api_beers' do
                get 'search', :on => :collection
                get 'autocomplete', :on => :collection
                get 'tag_autocomplete', :on => :collection
                get 'common_tags', :on => :collection
                get 'lookup_autocomplete', :on => :collection
                get 'show_simple', :on => :collection
              end
    resources :api_beer_notes, :controller => 'api_beer_notes' do
                get 'search', :on => :collection
                get 'tag_autocomplete', :on => :collection
                get 'common_tags', :on => :collection
                get 'lookup_autocomplete', :on => :collection
              end
              
    resources :api_distilleries, :controller => 'api_distilleries' do
                get 'search', :on => :collection
                get 'autocomplete', :on => :collection
                get 'tag_autocomplete', :on => :collection
                get 'common_tags', :on => :collection
                get 'lookup_autocomplete', :on => :collection
                get 'show_simple', :on => :collection
              end
    resources :api_spirits, :controller => 'api_spirits' do
                get 'search', :on => :collection
                get 'autocomplete', :on => :collection
                get 'tag_autocomplete', :on => :collection
                get 'common_tags', :on => :collection
                get 'lookup_autocomplete', :on => :collection
                get 'show_simple', :on => :collection
              end
    resources :api_spirit_notes, :controller => 'api_spirit_notes' do
                get 'search', :on => :collection
                get 'tag_autocomplete', :on => :collection
                get 'common_tags', :on => :collection
                get 'lookup_autocomplete', :on => :collection
              end
  #end


	root :to => "home#index"
	match '/about' => "home#about", :as => :about
	match '/features' => "home#features", :as => :features
	match '/contact' => "home#contact", :as => :contact
	match '/terms' => "home#terms", :as => :terms
	match '/ios_app' => "home#ios_app", :as => :ios_app
	
	match '/monitor' => "monitor#index", :as => :monitor
	match '/monitor/exceptions/:id' => "monitor#exception", :as => :exception
	match '/monitor/exceptions' => "monitor#exceptions", :as => :exceptions

  resources :taster_sessions, :password_resets
  match 'login' => 'taster_sessions#new', :as => :login
  match 'logout' => 'taster_sessions#destroy', :as => :logout
  
  match '/register/re_send' => 'activations#re_send', :as => :re_send_activation_email
  match '/register/:activation_code' => 'activations#new', :as => :register
  match '/activate/:id' => 'activations#create', :as => :activate
  match '/errors/message' => 'errors#message', :as => :error_message
  
  resources :tags, :admin_tags do
              get 'autocomplete', :on => :collection
            end
  
  resources :friendships
  
  resources :lookups, :reference_lookups do
              get 'search', :on => :collection
              get 'autocomplete', :on => :collection
              post 'add_admin_tag', :on => :member
              post 'remove_admin_tag', :on => :member
            end
  
  match '/reference_lookup_resources' => 'reference_lookups#resources', :as => :reference_lookup_resources
  
  resources :reference_breweries, :reference_wineries, :reference_distilleries do
              get 'search', :on => :collection
              get 'autocomplete', :on => :collection
              post 'add_admin_tag', :on => :member
              post 'remove_admin_tag', :on => :member
            end
            
  resources :reference_beers, :reference_wines, :reference_spirits do
              get 'search', :on => :collection
              post 'add_admin_tag', :on => :member
              post 'remove_admin_tag', :on => :member
            end
  
  match ':entity_type' => 'global_producers#browse', :as => 'browse_producers', :entity_type => producers_pattern
  match ':entity_type/search' => 'global_producers#search', :as => 'search_producers', :entity_type => producers_pattern
  
  match ':entity_type' => 'global_products#browse', :as => 'browse_products', :entity_type => products_pattern
  match ':entity_type/search' => 'global_products#search', :as => 'search_products', :entity_type => products_pattern
  
  match ':entity_type' => 'global_notes#browse', :as => 'browse_notes', :entity_type => notes_pattern
  match ':entity_type/search' => 'global_notes#search', :as => 'search_notes', :entity_type => notes_pattern
  
  resources :tasters do
    get 'search', :on => :collection
    member do
      get 'admin_profile'
      get 'delete'
      post 'add_admin_tag'
      post 'remove_admin_tag'
    end
    resources :breweries, :wineries, :distilleries,
              :beers, :wines, :spirits do
                get 'search', :on => :collection
                get 'autocomplete', :on => :collection
                get 'ajax_details', :on => :collection
                member do
                  get  'delete'
                  delete 'destroy'
                  post 'add_tag'
                  post 'remove_tag'
                  post 'add_admin_tag'
                  post 'remove_admin_tag'
                end
              end
    resources :beer_notes, :wine_notes, :spirit_notes do
                get 'search', :on => :collection
                member do
                  get  'delete'
                  delete 'destroy'
                  post 'add_tag'
                  post 'remove_tag'
                  post 'add_admin_tag'
                  post 'remove_admin_tag'
                end
              end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
