class StatisticsController < ApplicationController
  def show
    @number_of_penalties = current_user.penalties.count
    @number_of_connections = current_user.connections.count
    @number_of_open_connections = current_user.connections.find_by_end(nil).count
  end
end
