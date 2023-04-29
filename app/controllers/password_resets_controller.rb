class PasswordResetsController < ApplicationController
  skip_before_action :authenticate
  def new; end

  def edit
    # finds user with a valid token
    @user = User.find_signed!(params[:token], purpose: 'password_reset')
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to sign_in_path, alert: 'Your token has expired. Please try again.'
  end

  def update
    # updates user's password
    @user = User.find_signed!(params[:token], purpose: 'password_reset')
    if @user.update(password_params)
      redirect_to sign_in_path, notice: 'Your password was reset successfully. Please sign in'
    else
      render :edit
    end
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      # send mail
      # deliver_later is provided by ActiveJob
      PasswordMailer.with(user: @user).reset.deliver_later
      redirect_to sign_in_path, notice: 'Please check your email to reset the password'
    else
      flash.now[:alert] = 'Please enter the correct email which was used while registration!'
      render :new
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end