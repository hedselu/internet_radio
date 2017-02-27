class PlayersController < ApplicationController
  #before_action :authenticate_user!
  before_action :set_playlist

  def update
    container.pause_or_play(@playlist)
    head :ok
  end

  def destroy
    container.stop(@playlist)
    head :no_content
  end

  private

  def container
    Channels::WorkerContainer.instance
  end

  def set_playlist
    current_user = User.first
    @playlist = current_user.playlists.find(params[:playlist_id])
  end
end
