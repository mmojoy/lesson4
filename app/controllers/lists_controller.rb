class ListsController < ApplicationController
  before_action :authorize
  before_action :find_list, except: [:index, :create]

  def index
    @lists = List.for(current_user)
    @list = List.new
  end

  def show
    redirect_to list_tasks_path(@list.id)
  end

  def create
    @list = current_user.lists.create(list_params)
    if @list.save
      redirect_to list_tasks_path(@list.id)
    else
      redirect_to lists_path, notice: 'Invalid list name'
    end
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
    redirect_to lists_path, notice: 'list was destroyed'
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
