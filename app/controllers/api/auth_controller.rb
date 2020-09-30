class Api::AuthController < ApplicationController

  def login
    user = User.find_by(email: login_params[:email])
    if user && user.authenticate(login_params[:password])
      token = encode_token({ user_id: user.id })
      render_success(UserSerializer.new(user), jwt: token)
    else
      error_response('Invalid email or password')
    end
  end

  private
  def login_params
    params.require(:user).permit(:email, :password)
  end
end
