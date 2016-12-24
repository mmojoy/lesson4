class ListsController < ApplicationController
  before_action :authorize
  before_action :find_list, except: [:index, :create]

  def index
    @lists = List.for(current_user)
    @list = List.new
  end

  def create
    @list = current_user.lists.create(list_params)
    redirect_to list_tasks_path(@list.id) if @list.save
  end

  def share
    # debugger
    # @user = User.find_by(email: params[:email])
    # if @list.all_users.include?(@user)
    #   redirect_to list_tasks_path(@list), alert: 'This user is already added to the list'
    # else
    #   send_email
    #   @user.shared_lists << @list if @user
    #   redirect_to list_tasks_path(@list), notice: 'Email is sent to user'
    # end


    @list = List.find(params[:id])
    @user = User.find_by(email: params[:email])
    # debugger
    if @user
      create_lists_user [@user], @list
      UserNotifierMailer.send_signin_email(@user).deliver
      redirect_to list_tasks_path(@list), alert: 'This user is already added to the list'
    else
      UserNotifierMailer.send_signup_email(params[:email], @list).deliver
      redirect_to list_tasks_path(@list), notice: 'Email is sent to user'
    end

  end

  def destroy
    @list.destroy
  end

  private

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

  def list_params
    params.require(:list).permit(:title, :background_color)
  end

  def find_list
    @list = List.find(params[:id])
  end

  def send_email
    if @user
      ListMailer.join_list_email(@user, current_user, @list).deliver_later
    else
      ListMailer.join_app_email(params[:email], @list).deliver_later
      @list.pending_emails.create(email: params[:email])
    end
  end
end
