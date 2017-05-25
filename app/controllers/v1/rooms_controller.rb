class V1::RoomsController < ApplicationController
  before_action :authorize_user
  def index
    rooms = Room.all
    rooms = rooms.where("LOWER(name) LIKE ?", "%#{params[:name]}%") if params[:name].present?
    render json: {
      data: rooms
    }, status: 200
  end
  
  def show
    room = Room.find_by(room_code: params[:room_code])
    render json: {
      data: room
    }, status: 200
  end
  
end
