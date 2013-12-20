HvO::Application.routes.draw do

  constraints :subdomain => /.+/ do
    get '/' => 'initiatives#show'
    get '/wishlist' => "items#dashboard"
    get '/all_available_dates' => "available_dates#availability_dashboard"
    get '/profiles' => "profiles#index"

    # resources :initiatives
    
    get '/initiative/edit' => "initiatives#edit"
    delete '/initiative', :to => "initiatives#destroy"
    get '/initiative', :to => "initiatives#show"
    put '/initiative', :to => "initiatives#update"
    resources :initiatives
    resources :invitations
  end
  root to: "home#index"

  # get "/invitations/new", :to => "invitations#new", :as => "new_invitation"

  # post "/invitations", :to => "invitations#create", :as => "invitations"
  get "/invitations/:token/accept", :to => "invitations#accept", :as => "accept_invitation"
  post "/invitations/:token", :to => "invitations#register", :as => "register_user_via_invitation"

  resources :initiatives do
    # resources :invitations
    collection do
      get "new_from_bucket_group", :to => "initiatives#new_from_bucket_group"
    end
  end
  resources :bucket_groups, except: :index  do
    member do
      get 'admin_edit'
      delete 'destroy_user/:bgu_id', :to => "bucket_groups#destroy_user", as: "destroy_user"
    end
    collection do
      get "new_unregistered", :to => "bucket_groups#new_unregistered"
    end
    resources :invitations
  end
  # get '/initiatives/new', :to => "initiatives#new", :as => "new_initiative"
  # post '/initiative', :to => "initiatives#create", :as => "initiatives"

  #resources :initiatives, :except => [:index]
  #match "/settings", :to => "initiatives#edit"

	get "waardeverbinder", :as => "waardeverbinder_info", :to => "waardeverbinder#info"
  get "disclaimer", :as => "disclaimer", :to => "home#disclaimer"

  #Facebook login
	post '/auth/:provider/callback' => 'authentications#create'

  resources :messages, :except => [:edit, :show]
	get "feedback" => "messages#new"

  get "profiles/all", :as => "all_profiles", :to => "profiles#super_admin_index"
  get "initiative_profiles", :as => "all_initiative_profiles", :to => "profiles#initiative_user_index"
  resources :profiles, :except => [:index] do
		resources :available_dates, :except => [:show]
		#get "send_reminder", :to => "profiles#send_reminder_mail"
    get "contribution" => "profiles#contribution"
	end
  
  # devise_for :users

  devise_for :users, :skip => [:registrations]                                          
    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'    
      patch 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
      delete 'users/:id' => 'devise/registrations#destroy'            
    end

	devise_scope :user do
		get "login", :to => "devise/sessions#new"
		get "logout", :to => "devise/sessions#destroy"
	end

  #resources :initiatives, :except => [:index] #index is defined later on under admin scope

  resources :user_roles, :except => [:show, :edit, :index] 
  get '/calendar(/:year(/:month))' => 'projects#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
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
    resources :users
    get 'feedback', :to => 'messages#index', :as => "admin_feedback"
    get 'profiles', :to => "profiles#super_admin_index", :as => "admin_profiles"
    get 'initiatives', :to => "initiatives#index", :as => "admin_initiatives"
    get 'bucket_groups', to: "bucket_groups#index", :as => "admin_bucket_groups"
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

  # get '/*other', to: redirect('http://www.dreamyourapp.nl/%{other}')

end