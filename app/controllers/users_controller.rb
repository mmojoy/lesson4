class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if params[:user][:list_id]
        @list = List.find_by(id: params[:user][:list_id])
        if @list
          create_lists_user [@user], @list
        end
      end
      redirect_to root_url, notice: 'You signed up successfully'
    else
      render 'new'
    end
  end

  private

  def user_params
    params.fetch(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def create_lists_user(user_ids, list)
    user_ids.each do |item|
      if item.is_a?(User)
        user_object = item
      else
        user_object = User.find_by(id: item)
      end

      if user_object
        @lists_user = ListsUser.new
        @lists_user.user = user_object
        @lists_user.list = list
        @lists_user.save
      end
    end
  end
end
