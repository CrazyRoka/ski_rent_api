class UserController < ApplicationController
  before_action :authenticate_user
  skip_before_action :authenticate_user, only: :sign_up
  include Roar::Rails::ControllerAdditions
  respond_to :json

  # POST /api/sign_up
  def sign_up
    user = User.new(user_params)
    if user.save
      token = Knock::AuthToken.new payload: { sub: user.id }
      render json: token, status: :created
    else
      head :not_found
    end
  end

  # GET /api/users/me
  def me
    respond_with current_user
  end

  # PATCH /api/users
  def update
    if current_user.update(user_params)
      render json: current_user.extend(UserRepresenter)
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :city_id)
  end
end