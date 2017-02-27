module TokenAuth
  class SessionsController < DeviseTokenAuth::SessionsController

    def render_create_success
      render json: { data: UserSerializer.new(@resource).as_json }
    end
  end
end
