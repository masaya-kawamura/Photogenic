class ChatsController < ApplicationController

  def show
    @user = User.find(params[:id])
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    if user_rooms.nil?
      @room = Room.new
      @room.save
      UserRoom.create(user_id: @user.id, room_id: @room.id)
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
    else
      @room = user_rooms.room
    end
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
    user_rooms = current_user.user_rooms.pluck(:room_id)
    @users = User.includes(:user_rooms).order('user_rooms.updated_at DESC').where('room_id IN (?)', user_rooms).uniq - [current_user]
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
    user_rooms = UserRoom.where(room_id: @chat.room_id)
    user_rooms.each { |user_room| user_room.update(updated_at: Time.now) }
    @chats = @chat.room.chats
    user_rooms = current_user.user_rooms.pluck(:room_id)
    @users = User.includes(:user_rooms).order('user_rooms.updated_at DESC').where('room_id IN (?)', user_rooms).uniq - [current_user]
    @user = @users.first
  end

  def destroy
    @chat = Chat.find(params[:id])
    @chats = @chat.room.chats - [@chat]
    @chat.destroy
  end

    private

    def chat_params
      params.require(:chat).permit(:message, :user_id, :room_id)
    end

end
