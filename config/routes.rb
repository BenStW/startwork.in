# encoding: utf-8
StartWork::Application.routes.draw do


  resources :invitations

#  match 'friendships/create_all_fb_friends' => "friendships#create_all_fb_friends", :as => :create_friendship_all_fb_friends  
#  resources :friendships
#  match 'friendships/create_with_fb_friend/(:fb_ui)' => "friendships#create_with_fb_friend", :as => :create_friendship_with_fb_friend

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match 'appointment/receive' => 'appointments#receive', :as => :receive_appointment

  #only used internally for testing
  match 'appointment/send_appointment' => 'appointments#send_appointment', :as => :send_appointment
  match 'appointment/overview' => 'appointments#overview', :as => :overview_appointment
  #END OF only used internally for testing

  match 'appointment/show_and_welcome' => 'appointments#show_and_welcome', :as => :show_and_welcome_appointment

  match 'appointment/accept' => 'appointments#accept', :as => :accept_appointment
  match 'appointment/accept_and_redirect_to_appointment_with_welcome' => 'appointments#accept_and_redirect_to_appointment_with_welcome', :as => :accept_and_redirect_to_appointment_with_welcome
  match 'appointment/reject' => 'appointments#reject', :as => :reject_appointment


  #creates the following actions:
  # index
  # new
  # create
  # show
  # edit
  # update
  # destroy
  resources :appointments
  
  match 'welcome' => 'static_pages#welcome', :as => :welcome
  match 'login_to_accept_appointment' => 'static_pages#login_to_accept_appointment', :as => :login_to_accept_appointment 
  
  match 'weekly_overview' => 'user_hours#index', :as => :weekly_overview_user_hours
  match 'appointment/get_token' => 'appointments#get_token', :as => :get_token_appointment


  #  match 'appointment/accept_without_authentication' => 'appointments#accept_without_authentication', :as => :accept_without_authentication_appointment

#
#  match 'calendar' => 'calendar_events#show', :as => :calendar
#  match 'calendar/new_event' => 'calendar_events#new_event', :as => :calendar_new_event
#  match 'calendar/events' => 'calendar_events#events'  
#  match 'calendar/remove_event' => 'calendar_events#remove_event', :as => :calendar_remove_event
#  match 'calendar/remove_events_by_time' => 'calendar_events#remove_events_by_time', :as => :calendar_remove_events_by_time
#  match 'calendar/send_invitation' => 'calendar_events#send_invitation', :as => :calendar_send_invitation



 # scope "(:locale)", :locale => /en|de/  do
     root :to => 'static_pages#home'  


     match 'facebook' => 'static_pages#facebook', :as => :facebook
     match 'blog' => 'static_pages#blog', :as => :blog

     match 'effect' => 'static_pages#effect', :as => :effect
     match 'pilot_study' => 'static_pages#pilot_study', :as => :pilot_study
     match 'scientific_principles' => 'static_pages#scientific_principles', :as => :scientific_principles
     match 'how_it_works' => 'static_pages#how_it_works', :as => :how_it_works
     match 'impressum' => 'static_pages#impressum', :as => :impressum
     match 'about_us' => 'static_pages#about_us', :as => :about_us
     match 'camera' => 'static_pages#camera', :as => :camera
     match 'audio' => 'static_pages#audio', :as => :audio
     match 'ben' => 'static_pages#ben', :as => :ben
     match 'canvas' => 'static_pages#canvas', :as => :canvas
     match 'info_for_group_hour' => 'static_pages#info_for_group_hour', :as => :info_for_group_hour
     match 'session_start' => 'static_pages#session_start', :as => :session_start
     

      devise_for :users, :controllers => {:registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks" }       


      match 'group_hour' => 'group_hours#show', :as => :group_hour

     
     match 'group_hour/room_change(/:session)' => 'group_hours#room_change', :as => :group_hour_room_change
     match 'group_hour/get_time' => 'group_hours#get_time', :as => :group_hour_get_time
     match 'group_hour/group_hours' => 'group_hours#work_sessions', :as => :group_hours
     match 'group_hour/my_group_hours' => 'group_hours#my_group_hours', :as => :my_group_hours
     match 'group_hour' => 'group_hours#show', :as => :group_hour

     match 'test_work_session/:user' => 'work_sessions#test_show', :as => :test_work_session

 
    
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
