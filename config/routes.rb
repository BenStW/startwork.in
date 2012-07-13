# encoding: utf-8
StartWork::Application.routes.draw do


  resources :invitations

#  match 'friendships/create_all_fb_friends' => "friendships#create_all_fb_friends", :as => :create_friendship_all_fb_friends  
#  resources :friendships
#  match 'friendships/create_with_fb_friend/(:fb_ui)' => "friendships#create_with_fb_friend", :as => :create_friendship_with_fb_friend

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  match 'calendar' => 'calendar_events#show', :as => :calendar
  match 'calendar/new_event' => 'calendar_events#new_event', :as => :calendar_new_event
  match 'calendar/events' => 'calendar_events#events'  
  match 'calendar/remove_event' => 'calendar_events#remove_event', :as => :calendar_remove_event
  match 'calendar/remove_events_by_time' => 'calendar_events#remove_events_by_time', :as => :calendar_remove_events_by_time
  match 'calendar/send_invitation' => 'calendar_events#send_invitation', :as => :calendar_send_invitation

  match 'appointment' => 'appointments#show', :as => :appointment
  match 'appointment/get_token' => 'appointments#get_token', :as => :appointment_get_token
  match 'appointment/reject' => 'appointments#reject', :as => :appointment_reject
  match 'appointment/accept_without_authentication' => 'appointments#accept_without_authentication', :as => :appointment_accept_without_authentication
  match 'appointment/accept' => 'appointments#accept', :as => :appointment_accept


 # scope "(:locale)", :locale => /en|de/  do
     root :to => 'static_pages#home'  

     match 'welcome' => 'static_pages#welcome', :as => :welcome
     match 'welcome_with_appointment' => 'static_pages#welcome_with_appointment', :as => :welcome_with_appointment
     match 'accept_appointment' => 'static_pages#accept_appointment', :as => :accept_appointment
   #  match 'welcome_session' => 'static_pages#welcome_session', :as => :welcome_session
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
     match 'info_for_work_session' => 'static_pages#info_for_work_session', :as => :info_for_work_session
     match 'session_start' => 'static_pages#session_start', :as => :session_start
     

#     match 'send_facebook_message' => 'static_pages#send_facebook_message', :as => :send_facebook_message


   #  match 'interested_user'  => 'interested_user#show',:via => :get, :as => :show_interested_user   
  #   match 'interested_user' => 'interested_user#create',:via => :post, :as => :create_interested_user   
       
    
#     devise_for :users, :controllers => {:registrations => "registrations"} 
      devise_for :users, :controllers => {:registrations => "registrations", :omniauth_callbacks => "users/omniauth_callbacks" }       
#     devise_for :users, :controllers => {:registrations => "registrations", :omniauth_callbacks => "omniauth_callbacks" }       

     #devise_for :users, :controllers => {:sessions => "devise_sessions"}
     
     match 'work_session/room_change(/:session)' => 'work_sessions#room_change', :as => :work_session_room_change
     match 'work_session/get_time' => 'work_sessions#get_time', :as => :work_session_get_time
     match 'work_session/work_sessions' => 'work_sessions#work_sessions'  
     match 'work_session/my_work_sessions' => 'work_sessions#my_work_sessions', :as => :my_work_sessions
     match 'work_session' => 'work_sessions#show', :as => :work_session

 #    match 'spont_work_session' => 'work_sessions#spont_show', :as => :spont_work_session
     match 'test_work_session/:user' => 'work_sessions#test_show', :as => :test_work_session

   #  match 'guest_work_session' => 'work_sessions#show_for_guest', :as => :guest_work_session

    
 #    post 'connections/start', :to => 'connections#start'  
 #    post 'connections/end', :to => 'connections#end'
    

 
    
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
