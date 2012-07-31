ActiveAdmin::Dashboards.build do
  
  section "User statistics" do
    div do
      "#{User.all.count} users"    
    end    
       table_for User.registered?.each do 
         column 'id', :id
         column 'FB' do |user| raw "<img src='http://graph.facebook.com/#{user.fb_ui}/picture'" end 
         column 'name', :name
         column 'comment', :comment
         column 'friends' do |user|
            user.friends.count
         end
         column 'sponti sessions'  do |user| user.appointments.spont.count  end       
         column 'appointments'  do |user| user.appointments.not_spont.count  end       
         column 'user_hours'  do |user| user.user_hours.count  end       
         column 'logged-in user_hours' do |user| user.user_hours.until_now.logged_in.count end       
         column 'missed user_hours' do |user| user.user_hours.until_now.not_logged_in.count end       
         column 'perc. of logged-in user_hours' do  |user| 
            if user.user_hours.until_now.count>0
              "#{(user.user_hours.until_now.logged_in.count * 100 /
              (user.user_hours.until_now.count))} %" 
              else "-"
            end
         end 

       end       
  end    
  
  
  section "Current activities" do
       div do 
         "currently #{GroupHour.scope_current.count} GroupHours:"
       end
     
       table_for GroupHour.scope_current.each do
          column 'id', :id    
          column 'start_time' do |group_hour| 
            I18n.localize(group_hour.start_time.in_time_zone("Berlin")) 
          end
          column 'planned users' do |group_hour|
            group_hour.users.map(&:name)
          end
          column 'logged in users' do |group_hour|
            group_hour.users_logged_in.map(&:name)
          end          
        end 
  end  
  

  
                 
  
  
    # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  
  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }

end
