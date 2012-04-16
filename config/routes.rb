# encoding: utf-8
StartWork::Application.routes.draw do


  resources :invitations
  
  resources :friendships


  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match 'calendar' => 'calendar_events#show', :as => :calendar
  match 'calendar/new_event' => 'calendar_events#new_event'
  match 'calendar/get_events/(:user_ids)' => 'calendar_events#get_events'
  
  match 'calendar/remove_event' => 'calendar_events#remove_event'


 # scope "(:locale)", :locale => /en|de/  do
     root :to => 'static_pages#home'  

     match 'how_it_works' => 'static_pages#how_it_works', :as => :how_it_works
     match 'contact' => 'static_pages#contact', :as => :contact
     match 'about_us' => 'static_pages#about_us', :as => :about_us
     match 'camera' => 'static_pages#camera', :as => :camera
     match 'audio' => 'static_pages#audio', :as => :audio
     
     match 'study' => 'static_pages#study', :as => :study   
     match 'facebook' => 'static_pages#facebook', :as => :facebook        

     match 'interested_user'  => 'interested_user#show',:via => :get, :as => :show_interested_user   
     match 'interested_user' => 'interested_user#create',:via => :post, :as => :create_interested_user   
       
    
     #devise_for :users
     devise_for :users, :controllers => {:registrations => "registrations"}
     
     #devise_for :users, :controllers => {:sessions => "devise_sessions"}
     
    
     resources :groups
     match 'work_session/:id' => 'work_sessions#show', :as => :show_work_session
     match 'work_session/test/:username' => 'work_sessions#test', :as => :test_work_session        
     
    
     post '/connections/start', :to => 'connections#start'  
     post '/connections/end', :to => 'connections#end'
    
     match 'statistics' => 'statistics#show', :as => :statistics
    
    
     match 'penalties/add' => 'penalties#add'
     match 'penalties/latest' => 'penalties#latest'
     match 'penalties/cancel/:penalty_id' => 'penalties#cancel'  
     match 'penalties/end/:penalty_id' => 'penalties#end'  
    
 # end
  
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

ActionDispatch::Routing::Translator.translate_from_file('config/locales/routes.yml', { :prefix_on_default_locale => false })
