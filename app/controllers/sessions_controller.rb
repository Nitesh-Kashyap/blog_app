class SessionsController < ApplicationController
  skip_before_action :authenticate

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    respond_to do |format|
      # finds existing user, checks to see if user can be authenticated
      if @user.present? && @user.authenticate(params[:password])
        # sets up user.id sessions
        session[:user_id] = @user.id
        format.html { redirect_to root_path, notice: "Logged in successfully." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # deletes user session
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged Out'
  end

end