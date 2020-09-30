class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]

  # GET /api/users
  def index
    users = User.all
    render_success(ActiveModelSerializers::SerializableResource.new(users))
  end

  # GET /api/users/:id
  def show
    render_success(UserSerializer.new @user)
  end

  # PUT /api/users/:id
  def update
    if @user.update_attributes(user_params.except(:email))
      render_success(UserSerializer.new @user)
    else
      error_response(@user.errors.full_messages)
    end
  end

  # POST /api/users
  def create
    user = User.new(user_params)
    if user.save
      render_success(UserSerializer.new user)
    else
      render json: { error: user.errors.full_messages }, status: :not_acceptable
    end
  end
 
  private

    def set_user
      @user = User.find_by(id: params[:id])
      error_response('No user found') unless @user
    end

    def user_params
      params.require(:user).permit(:name, :password, :email)
    end
end
