class ApplicationController < ActionController::API
  include Knock::Authenticable
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    head :forbidden
  end
end
