HvO::Application.routes.draw do

	root :to => "initiatives#index"

	#Facebook login
	match '/auth/:provider/callback' => 'authentications#create'

  resources :messages, :except => [:edit, :show]
	match "feedback" => "messages#new"

  resources :profiles do
		resources :available_dates, :except => [:show]
		get "availability_dashboard", :to => "available_dates#availability_dashboard"
		#get "send_reminder", :to => "profiles#send_reminder_mail"
	end

  devise_for :users
	devise_scope :user do
		get "login", :to => "devise/sessions#new"
		get "logout", :to => "devise/sessions#destroy"
	end

  resources :initiatives, :except => [:show] do #perhaps store initiative in session variable
		match '/calendar(/:year(/:month))' => 'projects#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
	  resources :projects, :except => [:show] do
		  resources :items, :only => [:index]
		end
		get "dashboard", :to => "items#dashboard"
	end

  resources :items, :except => [:show, :index]
	resources :links, :only => [:index]

	get "projects/info"
	get "available_dates/info"
	get "items/info"
	get "profiles/:id/info", :to => "profiles#info", :as => "profile_info"
	get "profiles/:profile_id/item/:id", :to => "profiles#remove_item", :as => "remove_item_from_profile"

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
