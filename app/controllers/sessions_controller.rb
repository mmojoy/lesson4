class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      sign_in(user)
      redirect_to lists_path
    else
      redirect_to '/login', alert: 'Email or password is incorrect!'
    end
  end

  def destroy
    session[:user_id] = nil
    cookies[:user_id] = nil
    redirect_to '/login', notice: 'You are logged out!'
  end

  private

  def sign_in(user)
    session[:user_id] = user.id
    cookies.signed[:user_id] = verifier.generate(user.id)
  end

  def verifier
    @verifier ||= ActiveSupport::MessageVerifier.new('jsdhf')
  end
end
