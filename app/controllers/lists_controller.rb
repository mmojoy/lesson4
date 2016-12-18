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
    @user = User.find_by(email: params[:email])
    if @list.all_users.include?(@user)
      redirect_to list_tasks_path(@list), alert: 'This user is already added to the list'
    else
      send_email
      @user.shared_lists << @list if @user
      redirect_to list_tasks_path(@list), notice: 'Email is sent to user'
    end
  end

  def destroy
    @list.destroy
  end

  private

  def list_params
    params.require(:list).permit(:title)
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
