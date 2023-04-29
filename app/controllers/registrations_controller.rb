class RegistrationsController < ApplicationController
  skip_before_action :authenticate, only: [:new, :create]

    # instantiates new user
    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      respond_to do |format|
        if @user.save
          WelcomeMailer.with(user: @user).welcome_email.deliver_now
          session[:user_id] = @user.id
          format.html { redirect_to root_path, notice: "Successfully created account." }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end


    private

    def user_params
      # strong parameters
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end