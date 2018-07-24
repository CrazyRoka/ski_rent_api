class UserController < ApplicationController
  before_action :authenticate_user
  skip_before_action :authenticate_user, only: :sign_up
  include Roar::Rails::ControllerAdditions
  respond_to :json

  def sign_up
    user = User.new(user_params)
    begin
      user.save!
      token = Knock::AuthToken.new payload: { sub: user.id }
      render json: token, status: :created
    rescue
      head :not_found
    end
  end

  def me
    respond_with current_user, :represent_with => UserRepresenter
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end