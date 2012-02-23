class StatisticsController < ApplicationController
  def show
    @number_of_penalties = current_user.penalties.count
    @number_of_connections = current_user.connections.count
  end
end
