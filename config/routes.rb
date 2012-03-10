StartWork::Application.routes.draw do




  #get "calendar/show"
  match 'work_session/:work_session_id/calendar' => 'calendars#show', :as => :work_session_calendar
  match 'work_session/:work_session_id/calendar/event_new' => 'calendars#event_new', :as => :work_session_calendar_event_new

 # get "work_sessions/show"

 # scope "(:locale)", :locale => /en|de/  do
     root :to => 'static_pages#home'  

     match 'how_it_works' => 'static_pages#how_it_works', :as => :how_it_works
     match 'contact' => 'static_pages#contact', :as => :contact
     match 'about_us' => 'static_pages#about_us', :as => :about_us
     match 'camera' => 'static_pages#camera', :as => :camera
    
     devise_for :users
     #devise_for :users, :controllers => {:sessions => "devise_sessions"}
     
    
     resources :groups
     match 'work_session/:id' => 'work_sessions#show', :as => :show_work_session    
     
    
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
