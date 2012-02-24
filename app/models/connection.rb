class Connection < ActiveRecord::Base
  belongs_to :user
  
  def duration 
    if end_time.nil?
      0
    else
      end_time - start_time
    end
    
  end
end
