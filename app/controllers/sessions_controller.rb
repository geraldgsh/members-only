# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    puts 'hello'
    user = User.find_by(email: params[:session][:email].downcase)
    puts 'bye'
    if user&.authenticate(params[:session][:password])
      flash[:success] = 'Thank you for signing in!'
      sign_in user
      redirect_to root_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
