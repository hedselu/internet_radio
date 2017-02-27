class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def show
    icecast_status = Icecast::Status.new(current_user.channel.name)
    render json: icecast_status.fetch
  end
end
