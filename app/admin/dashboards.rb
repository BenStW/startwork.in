ActiveAdmin::Dashboards.build do
  section "Calendar statistics" do
    ul do
      li "#{CalendarEvent.this_week.count} calendar events this week"
      li "#{CalendarEvent.today.count} calendar events today"    
      li "#{WorkSession.current.count} current worksessions"
    end    
  end
  
  section "User statistics" do
    div do
      "#{User.all.count} users"    
    end    
       table_for User.all.each do 
         column 'id', :id
         column 'name', :name
         column 'comment', :comment
         column 'friends' do |user|
            user.friends.count
         end
         column 'calendar events'  do |user| user.calendar_events.after_logging_day.count  end       
         column 'logged-in  events' do |user| user.calendar_events.logged_in.count end       
         column 'missed  events' do |user| user.calendar_events.not_logged_in.count end       
         column 'perc. of logged-in events' do  |user| 
            if user.calendar_events.after_logging_day.count>0
              "#{(user.calendar_events.logged_in.count * 100 /
              (user.calendar_events.after_logging_day.count))} %" 
              else "-"
            end
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
