ActiveAdmin.register Friendship do
  menu :priority => 4
  filter :user
  filter :friend
  
  index do
      h2 "Aktuell gibt es nur reziproke Freundschaften"
      column :id
      column :user
      column :friend
    #  default_actions
    end
end
