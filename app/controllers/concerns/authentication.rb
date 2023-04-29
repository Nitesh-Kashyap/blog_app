module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  private
    def authenticate
      if session[:user_id].present?
        # finds user with session data and stores it if present
        Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
      else
        redirect_to sign_in_url, notice: 'Please sign in to continue!'
      end
    end
end