class CalendarsController < ApplicationController
  def show
  end
  
  def new_time
    work_session = WorkSession.find(params[:work_session_id])
    logger.info "create new start_time #{params[:start_time]} - #{params[:start_time].class}"
    start_time = DateTime.parse(params[:start_time])
    end_time = DateTime.parse(params[:end_time])  

    t=work_session.create_work_session_times(start_time,end_time)
    work_session.save
    render :json => "succussfully saved event"
  end

  def all_times
    work_session = WorkSession.find(params[:work_session_id])  
    times = work_session.all_times_of_this_week
    times_array = Array.new
    for time in times
      t_hash = Hash.new
      t_hash[:id] = time.id 
      logger.info "send back start_time #{time.start_time}"
      t_hash[:start] = time.start_time
      t_hash[:end] = time.start_time + 1.hour
      t_hash[:title] = ""    
      times_array.push(t_hash)
    end
    render :json =>  times_array.to_json  
  end
end

=begin
#jquery
start_time="Mon Mar 12 2012 08:00:00 GMT+0100 (CET)", end_time="Mon Mar 12 2012 09:00:00 GMT+0100 (CET)"}

#controller: string
start_time: Mon Mar 12 2012 08:00:00 GMT+0100 (CET), end_time: Mon Mar 12 2012 09:00:00 GMT+0100 (CET)

#model: parse into DateTime
start_time 2012-03-12T08:00:00+01:00

#save to database
start_time: Mon, 12 Mar 2012 08:00:00 UTC +00:00 

#load from database
start_time 2012-03-12 08:00:00 UTC

--
console: 
parse into DateTime:
start_time Mon, 12 Mar 2012 08:00:00 +0100 

save to datebase
start_time 2012-03-12 07:00:00


=end