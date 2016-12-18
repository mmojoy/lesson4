# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ListsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lists_channel_#{params[:list]}"
    redis.sadd "list_#{params[:list]}_online", current_user.id
    broadcast_status(redis.smembers("list_#{params[:list]}_online"))
  end

  def unsubscribed
    redis.srem "list_#{params[:list]}_online", current_user.id
    broadcast_status(redis.smembers("list_#{params[:list]}_online"))
  end

  def broadcast_status(users)
    ActionCable.server.broadcast("lists_channel_#{params[:list]}", online_users: users)
  end

  private

  def redis
    Redis.current
  end
end
