class StatisticsController < ApplicationController
  def show
    @number_of_connections = current_user.connections.count
    
    @duration_of_connections = current_user.duration_of_connections
      
    @connections = current_user.connections
  end
end
