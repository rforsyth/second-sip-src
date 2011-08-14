SsRails::Application.routes.draw do

  username_pattern = /[a-zA-Z0-9_]{3,16}/  # no anchor characters required in routes
	producers_pattern = /breweries|wineries|distilleries/
	products_pattern = /beers|wines|spirits/
	notes_pattern = /beer_notes|wine_notes|spirit_notes/
  #match 'tasters/:username' => 'tasters#show', :username => username_pattern

	root :to => "home#index"

  resources :taster_sessions
  match 'login' => 'taster_sessions#new', :as => :login
  match 'logout' => 'taster_sessions#destroy', :as => :logout
  
  resources :lookups, :reference_lookups
  resources :friendships, :tags, :resources
  resources :reference_producers, :reference_products
  
  match ':entity_type' => 'global_producers#browse', :as => 'browse_producers', :entity_type => producers_pattern
  match ':entity_type/search' => 'global_producers#search', :as => 'search_producers', :entity_type => producers_pattern
  
  match ':entity_type' => 'global_products#browse', :as => 'browse_products', :entity_type => products_pattern
  match ':entity_type/search' => 'global_products#search', :as => 'search_products', :entity_type => products_pattern
  
  match ':entity_type' => 'global_notes#browse', :as => 'browse_notes', :entity_type => notes_pattern
  match ':entity_type/search' => 'global_notes#search', :as => 'search_notes', :entity_type => notes_pattern
  
  # resources :reference_breweries, :reference_wineries, :reference_distilleries,
  #           :reference_beers, :reference_wines, :reference_spirits
  
  
  resources :tasters do
    resources :breweries, :wineries, :distilleries,
              :beers, :wines, :spirits,
              :beer_notes, :wine_notes, :spirit_notes do
                get 'search', :on => :collection
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
