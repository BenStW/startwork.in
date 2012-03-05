class StatisticsController < ApplicationController
  def show
    @number_of_penalties = current_user.penalties.count
    @number_of_connections = current_user.connections.count
    
    @duration_of_connections=0
    for connection in current_user.connections
      @duration_of_connections += connection.duration
    end
      
    @connections = current_user.connections
    @penalties = current_user.penalties  
  end
end
