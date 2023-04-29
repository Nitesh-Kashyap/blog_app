class WelcomeMailer < ApplicationMailer
	def welcome_email
      @user = params[:user]
      @url = 'http://localhost:3000/login'
      mail(to: @user.email, subject: 'Welcome to my Website')
    end
end
