class StatisticsController < ApplicationController
  def show
    @number_of_penalties = current_user.penalties.count
    @number_of_connections = current_user.connections.count
    
    @duration_of_connections = current_user.duration_of_connections
      
    @connections = current_user.connections
    @penalties = current_user.penalties  
  end
end
