class PlaylistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_playlist, except: %i(index create)

  def index
    render json: current_user.playlists
  end

  def show
    render json: @playlist
  end

  def create
    playlist = Playlist.new(playlist_params)

    if current_user.playlists << playlist
      render json: playlist, location: playlist, status: :created
    else
      render json: { errors: playlist.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    if @playlist.update(playlist_params)
      render json: @playlist, status: :ok
    else
      render json: { errors: @playlist.errors.messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @playlist.delete
    head :no_content
  end

  private

  def set_playlist
    @playlist = current_user.playlists.find(params[:id])
  end

  def playlist_params
    params.require(:playlist).permit(:name, :description, :song_ids, song_ids: [])
  end
end
