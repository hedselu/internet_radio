class SongsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_song, except: %i(index create)

  def index
    render json: current_user.songs
  end

  def show
    render json: @song
  end

  def create
    song = Song.new
    song.file = songs_params[:file]

    if song.valid?
      current_user.songs << song
      render json: song, status: :created
    else
      render json: { errors: song.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @song.destroy
    head :no_content
  end

  private

  def set_song
    @song = current_user.songs.find(params[:id])
  end

  def songs_params
    params.permit(:file)
  end
end
