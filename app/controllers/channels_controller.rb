class ChannelsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_channel, except: :index

  def index
    render json: Channel.where(active: true)
  end

  def create
    channel = current_user.build_channel(channel_params)

    if channel.save
      render json: channel, status: :created
    else
      render json: { errors: channel.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    if @channel.update(channel_params)
      render json: @channel, status: :ok
    else
      render json: { errors: @channel.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def channel_params
    params.require(:channel).permit(:name)
  end

  def set_channel
    @channel = current_user.channel
  end
end
