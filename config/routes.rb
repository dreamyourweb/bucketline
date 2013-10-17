HvO::Application.routes.draw do

  get "/invitations/new", :to => "invitations#new", :as => "new_invitation"
  post "/invitations", :to => "invitations#create", :as => "invitations"
  get "/invitations/:token/accept", :to => "invitations#accept", :as => "accept_invitation"
  post "/invitations/:token", :to => "invitations#register", :as => "register_user_via_invitation"

  constraints :subdomain => /.+/ do
    match '/' => 'projects#index'
    match '/wishlist' => "items#dashboard"
    match '/all_available_dates' => "available_dates#availability_dashboard"
    match '/profiles' => "profiles#index"
    
    match '/initiative/edit' => "initiatives#edit", :as => "edit_initiative"
    delete '/initiative', :to => "initiatives#destroy", :as => "initiative"
    get '/initiative', :to => "initiatives#show", :as => "initiative" #Something wrong with this
    put '/initiative', :to => "initiatives#update", :as => "initiative"
  end
  match '/initiatives/new', :to => "initiatives#new", :as => "new_initiative"
  post '/initiative', :to => "initiatives#create", :as => "initiatives"

  #resources :initiatives, :except => [:index]
  #match "/settings", :to => "initiatives#edit"

  root :to => "home#index"

	get "waardeverbinder", :as => "waardeverbinder_info", :to => "waardeverbinder#info"
  get "disclaimer", :as => "disclaimer", :to => "home#disclaimer"

  #Facebook login
	match '/auth/:provider/callback' => 'authentications#create'

  resources :messages, :except => [:edit, :show]
	match "feedback" => "messages#new"

  get "profiles/all", :as => "all_profiles", :to => "profiles#super_admin_index"
  get "initiative_profiles", :as => "all_initiative_profiles", :to => "profiles#initiative_user_index"
  resources :profiles, :except => [:index] do
		resources :available_dates, :except => [:show]
		#get "send_reminder", :to => "profiles#send_reminder_mail"
    get "contribution" => "profiles#contribution"
	end
  
  devise_for :users
	devise_scope :user do
		get "login", :to => "devise/sessions#new"
		get "logout", :to => "devise/sessions#destroy"
	end

  #resources :initiatives, :except => [:index] #index is defined later on under admin scope

  resources :user_roles, :except => [:show, :edit, :index] 
  match '/calendar(/:year(/:month))' => 'projects#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
	resources :items, :except => [:index, :show] #loose items
	get "dashboard", :to => "items#dashboard"
  get "availability_dashboard", :to => "available_dates#availability_dashboard"
	resources :links, :only => [:index]
  #get "profiles", :to => "profiles#index"

  resources :projects, :except => [:show] do
    resources :items, :only => [:index, :update] #items belonging to projects
  end

  resources :messages, :except => [:index]

  scope "/admin" do
    get 'feedback', :to => 'messages#index', :as => "admin_feedback"
    get 'profiles', :to => "profiles#super_admin_index", :as => "admin_profiles"
    get 'initiatives', :to => "initiatives#index", :as => "admin_initiatives"
  end

	get "projects/info"
	get "available_dates/info"
	get "items/info"
	get "profiles/:id/info", :to => "profiles#info", :as => "profile_info"
	get "profiles/:profile_id/item/:id", :to => "profiles#remove_item", :as => "remove_item_from_profile"

  get "terms_and_conditions", :as => "terms_and_conditions", :to => "home#terms_and_conditions"

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
