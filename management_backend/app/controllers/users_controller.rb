class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: current_user
  end

  def update
    if current_user.update(user_params)
      render json: current_user, status: :ok
    else
      render json: current_user.errors.messages, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.delete
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
